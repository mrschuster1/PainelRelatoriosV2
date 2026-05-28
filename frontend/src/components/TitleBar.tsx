import { WindowMinimise, WindowToggleMaximise, Quit } from '../../wailsjs/runtime';
import { useState } from 'react';
import iconLogo from '../assets/icon.png';

export function TitleBar() {
    const [isMaximized, setIsMaximized] = useState(true);

    const handleMinimize = () => WindowMinimise();
    const handleMaximize = () => {
        WindowToggleMaximise();
        setIsMaximized(!isMaximized);
    };
    const handleClose = () => Quit();

    return (
        <div className="title-bar" style={{ '--wails-draggable': 'drag' } as any}>
            <div className="title-bar-left">
                <div className="app-logo-mini">
                    <img src={iconLogo} alt="Logo" style={{ width: '16px', height: '16px', objectFit: 'contain' }} />
                </div>
                <span className="app-title-mini">Painel Relatórios</span>
            </div>
            
            <div className="title-bar-center">
                {/* Optional: Add search or active tab title here */}
            </div>

            <div className="title-bar-actions" style={{ '--wails-draggable': 'no-drag' } as any}>
                <button className="title-btn minimize" onClick={handleMinimize} title="Minimizar">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                </button>
                <button className="title-btn maximize" onClick={handleMaximize} title={isMaximized ? 'Restaurar' : 'Maximizar'}>
                    {isMaximized ? (
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="8" y="4" width="12" height="12" rx="1"></rect><path d="M4 8v12a1 1 0 0 0 1 1h12"></path></svg>
                    ) : (
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="4" y="4" width="16" height="16" rx="1"></rect></svg>
                    )}
                </button>
                <button className="title-btn close" onClick={handleClose} title="Fechar">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            
            <style>{`
                .title-bar {
                    height: 32px;
                    background: var(--bg-sidebar);
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    user-select: none;
                    border-bottom: 1px solid var(--border);
                    z-index: 9999;
                }
                .title-bar-left {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding-left: 12px;
                }
                .app-logo-mini {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .app-title-mini {
                    font-size: 11px;
                    font-weight: 700;
                    color: var(--text-muted);
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                }
                .title-bar-actions {
                    display: flex;
                    height: 100%;
                }
                .title-btn {
                    width: 46px;
                    height: 32px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: transparent;
                    border: none;
                    color: var(--text-muted);
                    transition: all 0.2s;
                    cursor: pointer;
                }
                .title-btn:hover {
                    background: rgba(255, 255, 255, 0.05);
                    color: var(--text-primary);
                }
                .title-btn.close:hover {
                    background: var(--danger);
                    color: white;
                }
            `}</style>
        </div>
    );
}
