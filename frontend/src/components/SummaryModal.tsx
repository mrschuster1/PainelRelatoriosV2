import { useMemo, useState } from 'react';
import { X, BarChart3, Eye, FileSpreadsheet, FileDown } from 'lucide-react';
import './SummaryModal.css';

interface SummaryModalProps {
    isOpen: boolean;
    onClose: () => void;
    data: any[];
    onExportExcel: (field: string, sortField: string, sortOrder: string) => void;
    onExportPDF: (field: string, sortField: string, sortOrder: string) => void;
    onPreviewPDF: (field: string, sortField: string, sortOrder: string) => void;
    initialField?: string;
    intendedAction?: 'preview' | 'excel' | 'pdf' | null;
}

const GROUP_OPTIONS = [
    { value: 'atendente', label: 'Analista' },
    { value: 'cliente', label: 'Cliente' },
    { value: 'sistema', label: 'Sistema' },
    { value: 'setor', label: 'Setor' },
    { value: 'acao', label: 'Ação' },
    { value: 'pessoa', label: 'Pessoa' },
    { value: 'categoria', label: 'Categoria' },
];

export function SummaryModal({ 
    isOpen, 
    onClose, 
    data, 
    onExportExcel, 
    onExportPDF, 
    onPreviewPDF,
    initialField = 'atendente',
    intendedAction = 'preview'
}: SummaryModalProps) {
    const [groupField, setGroupField] = useState(initialField);
    const [sortField, setSortField] = useState<'name' | 'count'>('count');
    const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');

    const summaryData = useMemo(() => {
        const counts: Record<string, number> = {};
        data.forEach(item => {
            const val = item[groupField as keyof any] || 'Não Informado';
            counts[val] = (counts[val] || 0) + 1;
        });

        return Object.entries(counts)
            .map(([name, count]) => ({ name, count }))
            .sort((a, b) => {
                let comparison = 0;
                if (sortField === 'count') {
                    comparison = a.count - b.count;
                } else {
                    comparison = a.name.localeCompare(b.name);
                }
                return sortOrder === 'desc' ? -comparison : comparison;
            });
    }, [data, groupField, sortField, sortOrder]);

    const total = useMemo(() => summaryData.reduce((sum, item) => sum + item.count, 0), [summaryData]);

    if (!isOpen) return null;

    const currentLabel = GROUP_OPTIONS.find(o => o.value === groupField)?.label || 'Agrupamento';

    const handleMainAction = () => {
        if (intendedAction === 'excel') onExportExcel(groupField, sortField, sortOrder);
        else if (intendedAction === 'pdf') onExportPDF(groupField, sortField, sortOrder);
        else onPreviewPDF(groupField, sortField, sortOrder);
    };

    const toggleSort = (field: 'name' | 'count') => {
        if (sortField === field) {
            setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
        } else {
            setSortField(field);
            setSortOrder('desc');
        }
    };

    return (
        <div className="modal-overlay summary-overlay" onClick={onClose}>
            <div className="modal-content summary-content" onClick={e => e.stopPropagation()}>
                <div className="summary-header">
                    <div className="header-icon">
                        <BarChart3 size={24} />
                    </div>
                    <div className="header-info">
                        <h2>Relatório Sintético</h2>
                        <p>Agrupar por <strong>{currentLabel}</strong></p>
                    </div>
                    <button className="close-btn" onClick={onClose}><X size={20} /></button>
                </div>
                
                    <div className="summary-config-grid">
                        <div className="config-item">
                            <label className="config-label">Agrupar por</label>
                            <div className="group-selector-premium">
                                {GROUP_OPTIONS.map(opt => (
                                    <button 
                                        key={opt.value}
                                        className={`group-opt-premium ${groupField === opt.value ? 'active' : ''}`}
                                        onClick={() => {
                                            setGroupField(opt.value);
                                        }}
                                    >
                                        {opt.label}
                                    </button>
                                ))}
                            </div>
                        </div>

                        <div className="config-item">
                            <label className="config-label">Ordenação</label>
                            <div className="sort-controls-compact">
                                <div className="sort-field-toggle">
                                    <button 
                                        className={`sort-toggle-btn ${sortField === 'name' ? 'active' : ''}`}
                                        onClick={() => setSortField('name')}
                                    >
                                        Nome
                                    </button>
                                    <button 
                                        className={`sort-toggle-btn ${sortField === 'count' ? 'active' : ''}`}
                                        onClick={() => setSortField('count')}
                                    >
                                        Quantidade
                                    </button>
                                </div>
                                <div className="sort-order-toggle">
                                    <button 
                                        className={`order-toggle-btn ${sortOrder === 'asc' ? 'active' : ''}`}
                                        onClick={() => setSortOrder('asc')}
                                        title="Crescente"
                                    >
                                        Crescente
                                    </button>
                                    <button 
                                        className={`order-toggle-btn ${sortOrder === 'desc' ? 'active' : ''}`}
                                        onClick={() => setSortOrder('desc')}
                                        title="Decrescente"
                                    >
                                        Decrescente
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                <div className="summary-preview-stats">
                    <div className="stat-card">
                        <span className="stat-label">Categorias</span>
                        <span className="stat-value">{summaryData.length}</span>
                    </div>
                    <div className="stat-card highlight">
                        <span className="stat-label">Total de Atendimentos</span>
                        <span className="stat-value">{total}</span>
                    </div>
                </div>

                <div className="summary-body">
                    <div className="summary-table-container">
                        <table className="summary-table">
                            <thead>
                                <tr>
                                    <th onClick={() => toggleSort('name')} className="sortable-header">
                                        {currentLabel} {sortField === 'name' && (sortOrder === 'asc' ? '↑' : '↓')}
                                    </th>
                                    <th onClick={() => toggleSort('count')} className="col-count sortable-header">
                                        Qtd {sortField === 'count' && (sortOrder === 'asc' ? '↑' : '↓')}
                                    </th>
                                    <th className="col-percent">%</th>
                                </tr>
                            </thead>
                            <tbody>
                                {summaryData.map((item, index) => (
                                    <tr key={index}>
                                        <td>{item.name}</td>
                                        <td className="col-count">{item.count}</td>
                                        <td className="col-percent">{((item.count / total) * 100).toFixed(1)}%</td>
                                    </tr>
                                ))}
                                {summaryData.length === 0 && (
                                    <tr>
                                        <td colSpan={3} style={{ textAlign: 'center', padding: '40px', color: 'var(--text-secondary)' }}>
                                            Nenhum dado disponível.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                <div className="summary-footer">
                    <div className="footer-actions">
                        <button className="btn btn-cancel" onClick={onClose}>Cancelar</button>
                        
                        <div className="action-divider"></div>

                        <button className={`btn btn-main-action ${intendedAction || 'preview'}`} onClick={handleMainAction}>
                            {intendedAction === 'excel' && <><FileSpreadsheet size={16} /> Gerar Excel</>}
                            {intendedAction === 'pdf' && <><FileDown size={16} /> Gerar PDF</>}
                            {(intendedAction === 'preview' || !intendedAction) && <><Eye size={16} /> Visualizar</>}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}


