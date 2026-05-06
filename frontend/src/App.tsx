import { useState, useEffect, useCallback, useRef } from 'react';
import './App.css';
import { Header } from './components/Header';
import { FilterPanel, FilterParams } from './components/FilterPanel';
import { DataGrid } from './components/DataGrid';
import { DatabaseSetup } from './components/DatabaseSetup';
import { ExportConfirmModal } from './components/ExportConfirmModal';
import { AboutModal } from './components/AboutModal';
import { GetAtendimentos, ExportAtendimentosExcel, ExportAtendimentosPDF, IsDatabaseConfigured, OpenFile } from '../wailsjs/go/main/App';
import { models } from '../wailsjs/go/models';

function App() {
    const [isConfigured, setIsConfigured] = useState(true);
    const [theme, setTheme] = useState<'dark' | 'light'>('dark');
    const [atendimentos, setAtendimentos] = useState<models.Atendimento[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [searchTerm, setSearchTerm] = useState('');
    const [showFilters, setShowFilters] = useState(true);
    const isInitialLoad = useRef(true);
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
    const [groupBy, setGroupBy] = useState('');

    const fetchAtendimentos = useCallback(async (currentFilters: any) => {
        setIsLoading(true);
        try {
            const data = await GetAtendimentos(currentFilters);
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
    }, []);

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

    const handleFilterChange = (formattedFilters: any) => {
        // We don't necessarily need to update the local 'filters' state here 
        // if we just want to trigger the search, but keeping track of them 
        // might be useful if we add more UI logic. 
        // However, the error TS2345 in App.tsx came from setFilters(newFilters).
        // Since FilterPanel returns formatted filters (strings), we should be careful.
        fetchAtendimentos(formattedFilters);
    };

    const handleExportExcel = async () => {
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
            unidades: filters.unidades.map(o => o.id)
        };
        try {
            const path = await ExportAtendimentosExcel(formatted as any);
            if (path) {
                setExportModal({ open: true, path });
            }
        } catch (err) {
            console.error("Erro ao exportar Excel:", err);
        }
    };

    const handleExportPDF = async () => {
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
            groupBy: groupBy
        };
        try {
            const path = await ExportAtendimentosPDF(formatted as any);
            if (path) {
                setExportModal({ open: true, path });
            }
        } catch (err) {
            console.error("Erro ao exportar PDF:", err);
        }
    };

    return (
        <div className={`app-container theme-${theme}`}>
            {!isConfigured ? (
                <DatabaseSetup onConfigured={() => setIsConfigured(true)} />
            ) : (
                <div className="app-layout">
                    <main className="main-stage">
                        <Header />
                        <div className="view-content">
                            <div className="view-header">
                                <div className="view-info">
                                    <h1 className="view-title">Pesquisa de Atendimentos</h1>
                                    <p className="view-subtitle">Filtre e visualize dados detalhados do sistema.</p>
                                </div>
                                <div className="view-actions">
                                    <button 
                                        className="btn-icon-only" 
                                        onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
                                        title={`Mudar para tema ${theme === 'dark' ? 'claro' : 'escuro'}`}
                                    >
                                        {theme === 'dark' ? (
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                                <circle cx="12" cy="12" r="5"></circle>
                                                <line x1="12" y1="1" x2="12" y2="3"></line>
                                                <line x1="12" y1="21" x2="12" y2="23"></line>
                                                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                                                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                                                <line x1="1" y1="12" x2="3" y2="12"></line>
                                                <line x1="21" y1="12" x2="23" y2="12"></line>
                                                <line x1="4.22" y1="18.36" x2="5.64" y2="16.92"></line>
                                                <line x1="18.36" y1="4.22" x2="19.78" y2="5.64"></line>
                                            </svg>
                                        ) : (
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                                            </svg>
                                        )}
                                    </button>
                                    <button 
                                        className="btn-icon-only" 
                                        onClick={() => setAboutModalOpen(true)}
                                        title="Sobre o App"
                                    >
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <line x1="12" y1="16" x2="12" y2="12"></line>
                                            <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                        </svg>
                                    </button>
                                    <button 
                                        className={`btn-icon-only ${showFilters ? 'active' : ''}`} 
                                        onClick={() => setShowFilters(!showFilters)} 
                                        title={showFilters ? "Recolher Filtros" : "Expandir Filtros"}
                                    >
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                                        </svg>
                                    </button>
                                    <div className="export-btns">
                                        <button className="btn btn-export" onClick={handleExportExcel}>Excel</button>
                                        <button className="btn btn-export" onClick={handleExportPDF}>PDF</button>
                                    </div>
                                </div>
                            </div>
                            
                            {showFilters && (
                                <div className="filter-wrapper">
                                    <FilterPanel 
                                        initialFilters={filters}
                                        onFilterChange={handleFilterChange} 
                                        onStateUpdate={setFilters}
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
                                onGroupingChange={setGroupBy}
                            />

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
                        </div>
                    </main>
                </div>
            )}
        </div>
    );
}

export default App;
