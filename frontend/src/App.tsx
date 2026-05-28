import { useState, useEffect, useCallback, useRef, useMemo } from 'react';
import './App.css';
import { Header } from './components/Header';
import { FilterPanel, FilterParams } from './components/FilterPanel';
import { DataGrid } from './components/DataGrid';
import { DatabaseSetup } from './components/DatabaseSetup';
import { ExportConfirmModal } from './components/ExportConfirmModal';
import { AboutModal } from './components/AboutModal';
import { SummaryCards } from './components/SummaryCards';
import { AnalyticsDashboard } from './components/AnalyticsDashboard';
import { SummaryModal } from './components/SummaryModal';
import { AnalyticModal } from './components/AnalyticModal';

import { GetAtendimentos, ExportAtendimentosExcel, ExportAtendimentosPDF, PreviewAtendimentosPDF, ExportSummaryExcel, ExportSummaryPDF, PreviewSummaryPDF, IsDatabaseConfigured, OpenFile, Login, GetAtendimentosPDFBase64, GetSummaryPDFBase64 } from '../wailsjs/go/main/App';
import { LoginScreen } from './components/Login';
import PDFViewerModal from './components/PDFViewerModal';

import { models } from '../wailsjs/go/models';
import { Layers, FileText, Database, FileDown, Eye, FileSpreadsheet, Plus, BarChart3 } from 'lucide-react';
import { SortingState } from '@tanstack/react-table';

function App() {
    const [isConfigured, setIsConfigured] = useState(true);
    const [currentUser, setCurrentUser] = useState<any>(null);
    const [atendimentos, setAtendimentos] = useState<models.Atendimento[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [searchTerm, setSearchTerm] = useState('');
    const [showFilters, setShowFilters] = useState(true);
    const isInitialLoad = useRef(true);
    const [grouping, setGrouping] = useState<string[]>(() => {
        const saved = localStorage.getItem('reporting_grouping');
        return saved ? JSON.parse(saved) : [];
    });
    const [sortByCount, setSortByCount] = useState(false);
    const [sorting, setSorting] = useState<SortingState>([]);
    const [activeTab, setActiveTab] = useState<'search' | 'analytics'>('search');
    const [theme, setTheme] = useState<'dark' | 'light'>(() => {
        return (localStorage.getItem('reporting_theme') as 'dark' | 'light') || 'dark';
    });
    const [showAnalytics, setShowAnalytics] = useState(() => {
        const saved = localStorage.getItem('painel_show_analytics');
        return saved !== null ? JSON.parse(saved) : true;
    });
    const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(() => {
        const saved = localStorage.getItem('reporting_sidebar_collapsed');
        return saved !== null ? JSON.parse(saved) : false;
    });

    // Handle theme changes
    useEffect(() => {
        localStorage.setItem('reporting_theme', theme);
        document.documentElement.className = theme === 'light' ? 'theme-light' : 'theme-dark';
    }, [theme]);

    // Handle sidebar persistence
    useEffect(() => {
        localStorage.setItem('reporting_sidebar_collapsed', JSON.stringify(isSidebarCollapsed));
    }, [isSidebarCollapsed]);

    // Handle grouping persistence
    useEffect(() => {
        localStorage.setItem('reporting_grouping', JSON.stringify(grouping));
    }, [grouping]);

    // Handle analytics visibility persistence
    useEffect(() => {
        localStorage.setItem('painel_show_analytics', JSON.stringify(showAnalytics));
    }, [showAnalytics]);

    const [filters, setFilters] = useState<FilterParams>({
        atendentes: [],
        clientes: [],
        sistemas: [],
        categorias: [],
        setores: [],
        acoes: [],
        unidades: [],
        tipoData: 'Abertura',
        dataInicio: new Date().toISOString().split('T')[0],
        dataFim: new Date().toISOString().split('T')[0]
    });

    const [exportModal, setExportModal] = useState<{ open: boolean; path: string }>({ open: false, path: '' });
    const [aboutModalOpen, setAboutModalOpen] = useState(false);
    const [summaryModalOpen, setSummaryModalOpen] = useState(false);
    const [summaryIntendedAction, setSummaryIntendedAction] = useState<'preview' | 'excel' | 'pdf' | null>(null);
    const [analyticModalOpen, setAnalyticModalOpen] = useState(false);
    const [analyticIntendedAction, setAnalyticIntendedAction] = useState<'preview' | 'excel' | 'pdf' | null>(null);
    const [pdfViewer, setPdfViewer] = useState<{ open: boolean; base64: string; title: string }>({ 
        open: false, 
        base64: '', 
        title: '' 
    });

    const sortParams = useMemo(() => {
        if (sortByCount) {
            return { field: 'count', order: 'DESC' };
        }
        if (sorting.length === 0) return { field: '', order: '' };
        return {
            field: sorting[0].id,
            order: sorting[0].desc ? 'DESC' : 'ASC'
        };
    }, [sorting, sortByCount]);


    const fetchAtendimentos = useCallback(async (currentFilters: any) => {
        setIsLoading(true);
        try {
            const data = await GetAtendimentos({
                ...currentFilters,
                sortField: sortParams.field,
                sortOrder: sortParams.order
            });
            setAtendimentos(data || []);
            // Auto-collapse filters if we found data and it's not the first load
            if (data && data.length > 0 && !isInitialLoad.current) {
                setShowFilters(false);
            }
            isInitialLoad.current = false;
        } catch (err) {
            console.error("Erro ao buscar atendimentos:", err);
        } finally {
            setIsLoading(false);
        }
    }, [sortParams]);

    const checkConfig = useCallback(async () => {
        try {
            const configured = await IsDatabaseConfigured();
            setIsConfigured(configured);
            if (configured) {
                // If we have filters from FilterPanel (which are formatted to IDs), use them
                // For initial load, we might need to format the default state
                const initialFilters = {
                    ...filters,
                    atendentes: filters.atendentes.map(o => o.id),
                    clientes: filters.clientes.map(o => o.id),
                    sistemas: filters.sistemas.map(o => o.id),
                    categorias: filters.categorias.map(o => o.id),
                    setores: filters.setores.map(o => o.id),
                    acoes: filters.acoes.map(o => o.id),
                    unidades: filters.unidades.map(o => o.id)
                };
                fetchAtendimentos(initialFilters);
            }
        } catch (err) {
            console.error("Erro ao verificar configuração:", err);
        }
    }, [filters, fetchAtendimentos]);

    useEffect(() => {
        checkConfig();
    }, []);

    const handleLoginSuccess = (user: any) => {
        setCurrentUser(user);
        checkConfig();
    };

    const handleLogout = () => {
        setCurrentUser(null);
    };

    const handleFilterChange = (formattedFilters: any) => {
        // We don't necessarily need to update the local 'filters' state here 
        // if we just want to trigger the search, but keeping track of them 
        // might be useful if we add more UI logic. 
        // However, the error TS2345 in App.tsx came from setFilters(newFilters).
        // Since FilterPanel returns formatted filters (strings), we should be careful.
        fetchAtendimentos(formattedFilters);
    };

    const handleExportExcel = async (sortField: string, sortOrder: string, groups: string[]) => {
        if (atendimentos.length === 0) {
            alert("Não há dados para exportar. Realize uma busca primeiro.");
            return;
        }
        const formatted = {
            ...filters,
            atendentes: filters.atendentes.map(o => o.id),
            clientes: filters.clientes.map(o => o.id),
            sistemas: filters.sistemas.map(o => o.id),
            categorias: filters.categorias.map(o => o.id),
            setores: filters.setores.map(o => o.id),
            acoes: filters.acoes.map(o => o.id),
            unidades: filters.unidades.map(o => o.id),
            groups: groups,
            sortField: sortField,
            sortOrder: sortOrder
        };
        try {
            const path = await ExportAtendimentosExcel(formatted as any);
            if (path) {
                setExportModal({ open: true, path });
                setAnalyticModalOpen(false);
            }
        } catch (err) {
            console.error("Erro ao exportar Excel:", err);
        }
    };

    const handleExportPDF = async (sortField: string, sortOrder: string, groups: string[]) => {
        if (atendimentos.length === 0) {
            alert("Não há dados para exportar. Realize uma busca primeiro.");
            return;
        }
        const formatted = {
            ...filters,
            atendentes: filters.atendentes.map(o => o.id),
            clientes: filters.clientes.map(o => o.id),
            sistemas: filters.sistemas.map(o => o.id),
            categorias: filters.categorias.map(o => o.id),
            setores: filters.setores.map(o => o.id),
            acoes: filters.acoes.map(o => o.id),
            unidades: filters.unidades.map(o => o.id),
            groups: groups,
            sortField: sortField,
            sortOrder: sortOrder
        };
        try {
            const path = await ExportAtendimentosPDF(formatted as any);
            if (path) {
                setExportModal({ open: true, path });
                setAnalyticModalOpen(false);
            }
        } catch (err) {
            console.error("Erro ao exportar PDF:", err);
        }
    };

    const handlePreviewAtendimentosPDF = async (sortField: string, sortOrder: string, groups: string[]) => {
        if (atendimentos.length === 0) {
            alert("Não há dados para visualizar. Realize uma busca primeiro.");
            return;
        }
        const formatted = {
            ...filters,
            atendentes: filters.atendentes.map(o => o.id),
            clientes: filters.clientes.map(o => o.id),
            sistemas: filters.sistemas.map(o => o.id),
            categorias: filters.categorias.map(o => o.id),
            setores: filters.setores.map(o => o.id),
            acoes: filters.acoes.map(o => o.id),
            unidades: filters.unidades.map(o => o.id),
            groups: groups,
            sortField: sortField,
            sortOrder: sortOrder
        };
        setIsLoading(true);
        try {
            const base64 = await GetAtendimentosPDFBase64(formatted as any);
            if (base64) {
                setPdfViewer({
                    open: true,
                    base64,
                    title: 'Relatório de Atendimentos'
                });
                setAnalyticModalOpen(false);
            }
        } catch (err) {
            console.error("Erro ao visualizar PDF:", err);
            alert("Erro ao gerar visualização do relatório.");
        } finally {
            setIsLoading(false);
        }
    };


    const handleExportSummaryExcel = async (field: string, sortField: string, sortOrder: string) => {
        if (atendimentos.length === 0) {
            alert("Não há dados para exportar. Realize uma busca primeiro.");
            return;
        }
        const formatted = {
            ...filters,
            atendentes: filters.atendentes.map(o => o.id),
            clientes: filters.clientes.map(o => o.id),
            sistemas: filters.sistemas.map(o => o.id),
            categorias: filters.categorias.map(o => o.id),
            setores: filters.setores.map(o => o.id),
            acoes: filters.acoes.map(o => o.id),
            unidades: filters.unidades.map(o => o.id),
            sortField: sortField,
            sortOrder: sortOrder
        };
        try {
            const path = await ExportSummaryExcel(formatted as any, field);
            if (path) {
                setExportModal({ open: true, path });
            }
        } catch (err) {
            console.error("Erro ao exportar Resumo Excel:", err);
        }
    };

    const handleExportSummaryPDF = async (field: string, sortField: string, sortOrder: string) => {
        if (atendimentos.length === 0) {
            alert("Não há dados para exportar. Realize uma busca primeiro.");
            return;
        }
        const formatted = {
            ...filters,
            atendentes: filters.atendentes.map(o => o.id),
            clientes: filters.clientes.map(o => o.id),
            sistemas: filters.sistemas.map(o => o.id),
            categorias: filters.categorias.map(o => o.id),
            setores: filters.setores.map(o => o.id),
            acoes: filters.acoes.map(o => o.id),
            unidades: filters.unidades.map(o => o.id),
            sortField: sortField,
            sortOrder: sortOrder
        };
        try {
            const path = await ExportSummaryPDF(formatted as any, field);
            if (path) {
                setExportModal({ open: true, path });
            }
        } catch (err) {
            console.error("Erro ao exportar Resumo PDF:", err);
        }
    };

    const handlePreviewSummaryPDF = async (field: string, sortField: string, sortOrder: string) => {
        if (atendimentos.length === 0) {
            alert("Não há dados para visualizar. Realize uma busca primeiro.");
            return;
        }
        const formatted = {
            ...filters,
            atendentes: filters.atendentes.map(o => o.id),
            clientes: filters.clientes.map(o => o.id),
            sistemas: filters.sistemas.map(o => o.id),
            categorias: filters.categorias.map(o => o.id),
            setores: filters.setores.map(o => o.id),
            acoes: filters.acoes.map(o => o.id),
            unidades: filters.unidades.map(o => o.id),
            sortField: sortField,
            sortOrder: sortOrder
        };
        setIsLoading(true);
        try {
            const base64 = await GetSummaryPDFBase64(formatted as any, field);
            if (base64) {
                setPdfViewer({
                    open: true,
                    base64,
                    title: `Relatório Sintético por ${field}`
                });
                setSummaryModalOpen(false); // Close the summary config modal when previewing
            }
        } catch (err) {
            console.error("Erro ao visualizar Resumo PDF:", err);
            alert("Erro ao gerar visualização do resumo.");
        } finally {
            setIsLoading(false);
        }
    };
    
    const handleDownloadPDFFromViewer = async () => {
        // Reuse existing file export logic if needed, or let PDFViewer handle it via blob
        // For now, let's just use the current ExportPDF/ExportSummaryPDF logic if we want consistency
        // or let the user use the download button in the viewer which uses the blob.
        // I'll stick to the blob download in the viewer for speed, but I could trigger the save dialog too.
    };

    return (
        <div className={`app-container theme-${theme}`}>
            {!currentUser ? (
                <LoginScreen 
                    theme={theme} 
                    onToggleTheme={() => setTheme(t => t === 'dark' ? 'light' : 'dark')} 
                    onLoginSuccess={handleLoginSuccess} 
                />
            ) : !isConfigured ? (
                <DatabaseSetup onConfigured={() => checkConfig()} />
            ) : (
                <div className={`app-layout ${isSidebarCollapsed ? 'sidebar-collapsed' : ''}`}>
                <aside className={`sidebar ${isSidebarCollapsed ? 'collapsed' : ''}`}>
                    <div className="sidebar-header">
                        <div className="sidebar-logo">
                            <div className="logo-icon">
                                <Layers color="white" size={24} />
                            </div>
                            {!isSidebarCollapsed && (
                                <div className="logo-text">
                                    <span className="logo-main-single">Painel Relatórios</span>
                                </div>
                            )}
                        </div>
                        <button 
                            className="btn-sidebar-toggle" 
                            onClick={() => setIsSidebarCollapsed(!isSidebarCollapsed)}
                            title={isSidebarCollapsed ? "Expandir" : "Recolher"}
                        >
                            {isSidebarCollapsed ? (
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            ) : (
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                                    <polyline points="15 18 9 12 15 6"></polyline>
                                </svg>
                            )}
                        </button>
                    </div>
                    
                    <nav className="nav-group">
                        <div 
                            className={`nav-item ${activeTab === 'search' ? 'active' : ''}`}
                            onClick={() => setActiveTab('search')}
                            title={isSidebarCollapsed ? "Pesquisa" : ""}
                        >
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            {!isSidebarCollapsed && <span>Pesquisa</span>}
                        </div>
                        <div 
                            className={`nav-item ${activeTab === 'analytics' ? 'active' : ''}`}
                            onClick={() => setActiveTab('analytics')}
                            title={isSidebarCollapsed ? "Dashboard" : ""}
                        >
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <line x1="18" y1="20" x2="18" y2="10"></line>
                                <line x1="12" y1="20" x2="12" y2="4"></line>
                                <line x1="6" y1="20" x2="6" y2="14"></line>
                            </svg>
                            {!isSidebarCollapsed && <span>Dashboard</span>}
                        </div>
                        <div 
                            className="nav-item" 
                            onClick={() => setAboutModalOpen(true)}
                            title={isSidebarCollapsed ? "Sobre" : ""}
                        >
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            {!isSidebarCollapsed && <span>Sobre</span>}
                        </div>
                    </nav>
                </aside>
                    <main className="main-content">
                    <Header 
                        theme={theme} 
                        onToggleTheme={() => setTheme(t => t === 'dark' ? 'light' : 'dark')} 
                        currentUser={currentUser}
                        onLogout={handleLogout}
                    />
                    <div className="page-canvas">
                            {activeTab === 'analytics' ? (
                                <>
                                    <div className="view-header">
                                        <div className="view-info">
                                            <h1 className="view-title">Análise de Dados</h1>
                                            <p className="view-subtitle">Visão geral e estatísticas dos atendimentos.</p>
                                        </div>
                                    </div>
                                    <SummaryCards data={atendimentos} />
                                    <AnalyticsDashboard data={atendimentos} />
                                </>
                            ) : (
                                <>
                                    <div className="view-header">
                                        <div className="view-info">
                                            <h1 className="view-title">Pesquisa de Atendimentos</h1>
                                            <p className="view-subtitle">Filtre e visualize dados detalhados do sistema.</p>
                                        </div>
                                        <div className="view-actions">
                                            <button 
                                                className={`btn-icon-only ${showFilters ? 'active' : ''}`} 
                                                onClick={() => setShowFilters(!showFilters)} 
                                                title={showFilters ? "Recolher Filtros" : "Expandir Filtros"}
                                            >
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                                    <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                                                </svg>
                                            </button>
                                            <div className="report-actions-container">
                                                {/* Card Relatório Analítico */}
                                                <div className="report-group-card">
                                                    <div className="report-group-header">
                                                        <div className="group-icon-wrapper analytic">
                                                            <FileText size={18} />
                                                        </div>
                                                        <div className="group-header-info">
                                                            <span className="group-title">Analítico</span>
                                                            <span className="group-subtitle">Lista detalhada</span>
                                                        </div>
                                                    </div>
                                                    <div className="report-group-btns">
                                                        <button className="btn-report preview" onClick={() => { setAnalyticIntendedAction('preview'); setAnalyticModalOpen(true); }} title="Visualizar PDF">
                                                            <Eye size={14} /> <span>Ver</span>
                                                        </button>
                                                        <button className="btn-report excel" onClick={() => { setAnalyticIntendedAction('excel'); setAnalyticModalOpen(true); }} title="Exportar Excel">
                                                            <FileSpreadsheet size={14} /> <span>Excel</span>
                                                        </button>
                                                        <button className="btn-report pdf" onClick={() => { setAnalyticIntendedAction('pdf'); setAnalyticModalOpen(true); }} title="Exportar PDF">
                                                            <FileDown size={14} /> <span>PDF</span>
                                                        </button>
                                                    </div>

                                                </div>

                                                {/* Card Relatório Sintético */}
                                                <div className="report-group-card">
                                                    <div className="report-group-header">
                                                        <div className="group-icon-wrapper synthetic">
                                                            <BarChart3 size={18} />
                                                        </div>
                                                        <div className="group-header-info">
                                                            <span className="group-title">Sintético</span>
                                                            <span className="group-subtitle">Totais agrupados</span>
                                                        </div>
                                                    </div>
                                                    <div className="report-group-btns">
                                                        <button className="btn-report preview" onClick={() => { setSummaryIntendedAction('preview'); setSummaryModalOpen(true); }} title="Configurar e Visualizar">
                                                            <Eye size={14} /> <span>Ver</span>
                                                        </button>
                                                        <button className="btn-report excel" onClick={() => { setSummaryIntendedAction('excel'); setSummaryModalOpen(true); }} title="Configurar e exportar Excel">
                                                            <FileSpreadsheet size={14} /> <span>Excel</span>
                                                        </button>
                                                        <button className="btn-report pdf" onClick={() => { setSummaryIntendedAction('pdf'); setSummaryModalOpen(true); }} title="Configurar e exportar PDF">
                                                            <FileDown size={14} /> <span>PDF</span>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    {showFilters && (
                                        <div className="filter-wrapper">
                                            <FilterPanel 
                                                initialFilters={filters}
                                                onFilterChange={handleFilterChange} 
                                                onStateUpdate={setFilters}
                                                currentUser={currentUser}
                                            />
                                        </div>
                                    )}

                                    <DataGrid 
                                        atendimentos={atendimentos} 
                                        isLoading={isLoading} 
                                        searchTerm={searchTerm}
                                        setSearchTerm={setSearchTerm}
                                        showFilters={showFilters}
                                        onToggleFilters={() => setShowFilters(true)}
                                        onGroupingChange={setGrouping}
                                        onSortingChange={setSorting}
                                        onSortByCountChange={setSortByCount}
                                    />
                                </>
                            )}

                            <ExportConfirmModal 
                                isOpen={exportModal.open}
                                onClose={() => setExportModal({ open: false, path: '' })}
                                onConfirm={async () => {
                                    await OpenFile(exportModal.path);
                                    setExportModal({ open: false, path: '' });
                                }}
                                title="Exportação Concluída"
                                message="Seu arquivo foi gerado com sucesso na pasta de exportações."
                            />

                            <AboutModal 
                                isOpen={aboutModalOpen} 
                                onClose={() => setAboutModalOpen(false)} 
                            />
                            <SummaryModal 
                                isOpen={summaryModalOpen} 
                                onClose={() => setSummaryModalOpen(false)} 
                                data={atendimentos}
                                onExportExcel={handleExportSummaryExcel}
                                onExportPDF={handleExportSummaryPDF}
                                onPreviewPDF={handlePreviewSummaryPDF}
                                intendedAction={summaryIntendedAction}
                            />

                            <AnalyticModal
                                isOpen={analyticModalOpen}
                                onClose={() => setAnalyticModalOpen(false)}
                                onExportExcel={handleExportExcel}
                                onExportPDF={handleExportPDF}
                                onPreviewPDF={handlePreviewAtendimentosPDF}
                                intendedAction={analyticIntendedAction}
                                dataCount={atendimentos.length}
                                initialSortField={sortParams.field || 'dataAbertura'}
                                initialSortOrder={(sortParams.order?.toLowerCase() as 'asc' | 'desc') || 'desc'}
                                initialGroups={grouping}
                            />

                            <PDFViewerModal 
                                isOpen={pdfViewer.open}
                                onClose={() => setPdfViewer({ ...pdfViewer, open: false })}
                                base64Data={pdfViewer.base64}
                                title={pdfViewer.title}
                            />
                        </div>
                    </main>
                </div>
            )}
        </div>
    );
}

export default App;
