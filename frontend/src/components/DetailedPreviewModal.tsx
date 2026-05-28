import React from 'react';
import './SummaryModal.css'; // Reuse common modal styles

interface DetailedPreviewModalProps {
    isOpen: boolean;
    onClose: () => void;
    data: any[];
    onExportExcel: () => void;
    onExportPDF: () => void;
}

export function DetailedPreviewModal({ isOpen, onClose, data, onExportExcel, onExportPDF }: DetailedPreviewModalProps) {
    if (!isOpen) return null;

    return (
        <div className="modal-overlay summary-overlay" onClick={onClose}>
            <div className="modal-content summary-content" style={{ width: '900px', maxWidth: '95vw' }} onClick={e => e.stopPropagation()}>
                <div className="summary-header">
                    <div className="header-icon" style={{ background: 'rgba(16, 185, 129, 0.2)', color: '#10b981' }}>
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                    </div>
                    <div className="header-info">
                        <h2>Prévia Relatório Analítico</h2>
                        <p>Mostrando <strong>{data.length}</strong> registros detalhados</p>
                    </div>
                    <button className="close-btn" onClick={onClose}>&times;</button>
                </div>
                
                <div className="summary-body" style={{ maxHeight: '70vh' }}>
                    <div className="summary-table-container">
                        <table className="summary-table">
                            <thead style={{ position: 'sticky', top: 0, zIndex: 20 }}>
                                <tr>
                                    <th>Cliente</th>
                                    <th>Pessoa</th>
                                    <th>Ação</th>
                                    <th>Sistema</th>
                                    <th>Analista</th>
                                    <th style={{ textAlign: 'center' }}>Abertura</th>
                                </tr>
                            </thead>
                            <tbody>
                                {data.map((item, index) => (
                                    <tr key={index}>
                                        <td style={{ fontSize: '12px' }}>{item.Cliente}</td>
                                        <td style={{ fontSize: '12px' }}>{item.Pessoa}</td>
                                        <td style={{ fontSize: '12px' }}>{item.Acao}</td>
                                        <td style={{ fontSize: '12px' }}>{item.Sistema}</td>
                                        <td style={{ fontSize: '12px' }}>{item.Atendente}</td>
                                        <td style={{ fontSize: '12px', textAlign: 'center' }}>
                                            {item.DataAbertura ? new Date(item.DataAbertura).toLocaleDateString('pt-BR') : '-'}
                                        </td>
                                    </tr>
                                ))}
                                {data.length === 0 && (
                                    <tr>
                                        <td colSpan={6} style={{ textAlign: 'center', padding: '40px', color: 'var(--text-secondary)' }}>
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
                        <button className="btn btn-secondary" onClick={onExportExcel}>Exportar Excel</button>
                        <button className="btn btn-secondary" onClick={onExportPDF}>Exportar PDF</button>
                        <button className="btn btn-primary" onClick={onClose}>Fechar</button>
                    </div>
                </div>
            </div>
        </div>
    );
}
