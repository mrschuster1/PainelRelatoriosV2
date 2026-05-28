import React, { useEffect, useState } from 'react';
import { X, Download, Printer, FileText, Share2 } from 'lucide-react';
import './PDFViewerModal.css';

interface PDFViewerModalProps {
    isOpen: boolean;
    onClose: () => void;
    base64Data: string;
    title: string;
    onDownload?: () => void;
}

const PDFViewerModal: React.FC<PDFViewerModalProps> = ({ 
    isOpen, 
    onClose, 
    base64Data, 
    title,
    onDownload 
}) => {
    const [pdfUrl, setPdfUrl] = useState<string>('');

    useEffect(() => {
        if (isOpen && base64Data) {
            // Convert base64 to Blob URL for the iframe
            try {
                const byteCharacters = atob(base64Data);
                const byteNumbers = new Array(byteCharacters.length);
                for (let i = 0; i < byteCharacters.length; i++) {
                    byteNumbers[i] = byteCharacters.charCodeAt(i);
                }
                const byteArray = new Uint8Array(byteNumbers);
                const blob = new Blob([byteArray], { type: 'application/pdf' });
                const url = URL.createObjectURL(blob);
                setPdfUrl(url);

                return () => {
                    URL.revokeObjectURL(url);
                };
            } catch (error) {
                console.error('Error creating PDF blob:', error);
            }
        }
    }, [isOpen, base64Data]);

    if (!isOpen) return null;

    const handlePrint = () => {
        const iframe = document.getElementById('pdf-iframe') as HTMLIFrameElement;
        if (iframe && iframe.contentWindow) {
            iframe.contentWindow.print();
        }
    };

    const handleDownload = () => {
        if (onDownload) {
            onDownload();
        } else {
            const link = document.createElement('a');
            link.href = pdfUrl;
            link.download = `${title.toLowerCase().replace(/\s+/g, '_')}.pdf`;
            link.click();
        }
    };

    return (
        <div className="pdf-viewer-overlay" onClick={onClose}>
            <div className="pdf-viewer-container" onClick={e => e.stopPropagation()}>
                <div className="pdf-viewer-header">
                    <div className="pdf-viewer-title">
                        <FileText className="pdf-icon" />
                        <h2>{title}</h2>
                    </div>
                    
                    <div className="pdf-viewer-actions">
                        <button className="pdf-action-btn secondary" onClick={handlePrint} title="Imprimir">
                            <Printer size={18} />
                            <span>Imprimir</span>
                        </button>
                        <button className="pdf-action-btn primary" onClick={handleDownload} title="Baixar">
                            <Download size={18} />
                            <span>Baixar</span>
                        </button>
                        <button className="pdf-action-btn close" onClick={onClose} title="Fechar">
                            <X size={24} />
                        </button>
                    </div>
                </div>
                
                <div className="pdf-viewer-content">
                    {pdfUrl ? (
                        <iframe 
                            id="pdf-iframe"
                            src={`${pdfUrl}#toolbar=0&navpanes=0&scrollbar=0`}
                            className="pdf-iframe"
                            title={title}
                        />
                    ) : (
                        <div className="flex items-center justify-center h-full text-slate-400">
                            Carregando visualização...
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default PDFViewerModal;
