import { useState } from 'react';
import { X, FileText, Eye, FileSpreadsheet, FileDown, ArrowUpDown, Layers } from 'lucide-react';
import './AnalyticModal.css';

interface AnalyticModalProps {
    isOpen: boolean;
    onClose: () => void;
    onExportExcel: (sortField: string, sortOrder: string, groups: string[]) => void;
    onExportPDF: (sortField: string, sortOrder: string, groups: string[]) => void;
    onPreviewPDF: (sortField: string, sortOrder: string, groups: string[]) => void;
    initialSortField?: string;
    initialSortOrder?: string;
    initialGroups?: string[];
    intendedAction?: 'preview' | 'excel' | 'pdf' | null;
    dataCount?: number;
}

const SORT_OPTIONS = [
    { value: 'dataAbertura', label: 'Abertura' },
    { value: 'dataFechamento', label: 'Fechamento' },
    { value: 'cliente', label: 'Cliente' },
    { value: 'atendente', label: 'Analista' },
    { value: 'sistema', label: 'Sistema' },
    { value: 'setor', label: 'Setor' },
    { value: 'categoria', label: 'Categoria' },
    { value: 'acao', label: 'Ação' },
    { value: 'id', label: 'Protocolo' },
];

const GROUP_OPTIONS = [
    { value: 'cliente', label: 'Cliente' },
    { value: 'atendente', label: 'Analista' },
    { value: 'sistema', label: 'Sistema' },
    { value: 'setor', label: 'Setor' },
    { value: 'categoria', label: 'Categoria' },
    { value: 'acao', label: 'Ação' },
    { value: 'pessoa', label: 'Pessoa' },
];

export function AnalyticModal({ 
    isOpen, 
    onClose, 
    onExportExcel, 
    onExportPDF, 
    onPreviewPDF,
    initialSortField = 'dataAbertura',
    initialSortOrder = 'desc',
    initialGroups = [],
    intendedAction = 'preview',
    dataCount = 0
}: AnalyticModalProps) {
    const [sortField, setSortField] = useState(initialSortField);
    const [sortOrder, setSortOrder] = useState(initialSortOrder);
    const [selectedGroups, setSelectedGroups] = useState<string[]>(initialGroups);

    if (!isOpen) return null;

    const handleMainAction = () => {
        if (intendedAction === 'excel') onExportExcel(sortField, sortOrder, selectedGroups);
        else if (intendedAction === 'pdf') onExportPDF(sortField, sortOrder, selectedGroups);
        else onPreviewPDF(sortField, sortOrder, selectedGroups);
    };

    const toggleGroup = (val: string) => {
        setSelectedGroups(prev => 
            prev.includes(val) ? prev.filter(g => g !== val) : [...prev, val]
        );
    };

    return (
        <div className="modal-overlay analytic-overlay" onClick={onClose}>
            <div className="modal-content analytic-content" onClick={e => e.stopPropagation()}>
                <div className="analytic-header">
                    <div className="header-icon">
                        <FileText size={24} />
                    </div>
                    <div className="header-info">
                        <h2>Relatório Analítico</h2>
                        <p>Ordenado por <strong>{SORT_OPTIONS.find(o => o.value === sortField)?.label}</strong></p>
                    </div>
                    <button className="close-btn" onClick={onClose}><X size={20} /></button>
                </div>

                <div className="analytic-preview-stats">
                    <div className="stat-card highlight">
                        <span className="stat-label">Total de Registros</span>
                        <span className="stat-value">{dataCount}</span>
                    </div>
                </div>

                <div className="analytic-body">
                    <div className="analytic-config-grid">
                        <div className="config-item">
                            <label className="config-label">Ordenar por</label>
                            <div className="sort-selector-grid">
                                {SORT_OPTIONS.map(opt => (
                                    <button 
                                        key={opt.value}
                                        className={`sort-opt-premium ${sortField === opt.value ? 'active' : ''}`}
                                        onClick={() => setSortField(opt.value)}
                                    >
                                        {opt.label}
                                    </button>
                                ))}
                            </div>
                        </div>

                        <div className="config-item">
                            <label className="config-label">Ordem</label>
                            <div className="order-toggle-premium">
                                <button 
                                    className={`order-btn-premium ${sortOrder === 'asc' ? 'active' : ''}`}
                                    onClick={() => setSortOrder('asc')}
                                >
                                    Crescente
                                </button>
                                <button 
                                    className={`order-btn-premium ${sortOrder === 'desc' ? 'active' : ''}`}
                                    onClick={() => setSortOrder('desc')}
                                >
                                    Decrescente
                                </button>
                            </div>
                        </div>
                    </div>

                    <section className="config-section">
                        <div className="section-title">
                            <Layers size={16} />
                            <span>Agrupamento (Opcional)</span>
                        </div>
                        <p className="section-hint">Os dados serão organizados em blocos por estas colunas.</p>
                        <div className="group-chips">
                            {GROUP_OPTIONS.map(opt => (
                                <button 
                                    key={opt.value}
                                    className={`group-chip ${selectedGroups.includes(opt.value) ? 'active' : ''}`}
                                    onClick={() => toggleGroup(opt.value)}
                                >
                                    {opt.label}
                                </button>
                            ))}
                        </div>
                    </section>
                </div>

                <div className="analytic-footer">
                    <div className="footer-actions">
                        <button className="btn btn-cancel" onClick={onClose}>Cancelar</button>
                        <div className="action-divider"></div>
                        <button className={`btn btn-main-action ${intendedAction || 'preview'}`} onClick={handleMainAction}>
                            {intendedAction === 'excel' && <><FileSpreadsheet size={16} /> Exportar Excel</>}
                            {intendedAction === 'pdf' && <><FileDown size={16} /> Exportar PDF</>}
                            {(intendedAction === 'preview' || !intendedAction) && <><Eye size={16} /> Visualizar Relatório</>}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
