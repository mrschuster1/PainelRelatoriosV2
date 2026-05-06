import React from 'react';
import { X, CheckCircle2, ExternalLink } from 'lucide-react';

interface ExportConfirmModalProps {
    isOpen: boolean;
    onClose: () => void;
    onConfirm: () => void;
    title: string;
    message: string;
}

export function ExportConfirmModal({ isOpen, onClose, onConfirm, title, message }: ExportConfirmModalProps) {
    if (!isOpen) return null;

    return (
        <div className="modal-overlay" onClick={onClose} style={{ zIndex: 2000 }}>
            <div className="modal-content confirm-modal" onClick={e => e.stopPropagation()} style={{ maxWidth: '400px' }}>
                <div className="modal-header">
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                        <CheckCircle2 size={20} color="var(--success)" />
                        <h3>{title}</h3>
                    </div>
                    <button className="modal-close" onClick={onClose}><X size={20} /></button>
                </div>
                <div className="modal-body" style={{ textAlign: 'center', padding: '32px 24px' }}>
                    <p style={{ color: 'var(--text-secondary)', fontSize: '15px', lineHeight: '1.5', marginBottom: '24px' }}>
                        {message}
                    </p>
                    <div style={{ display: 'flex', gap: '12px', justifyContent: 'center' }}>
                        <button className="btn btn-ghost" onClick={onClose} style={{ flex: 1 }}>
                            Agora não
                        </button>
                        <button className="btn btn-solid" onClick={onConfirm} style={{ flex: 1, gap: '8px' }}>
                            <ExternalLink size={16} />
                            Abrir Arquivo
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}
