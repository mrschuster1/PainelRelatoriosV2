import { useState } from 'react';
import { SaveDatabaseConfig, TestDatabaseConfig } from '../../wailsjs/go/main/App';

interface DatabaseSetupProps {
    onConfigured: () => void;
}

export function DatabaseSetup({ onConfigured }: DatabaseSetupProps) {
    const [config, setConfig] = useState({
        host: '127.0.0.1',
        port: '3306',
        user: '',
        pass: '',
        name: ''
    });
    const [isTesting, setIsTesting] = useState(false);
    const [isSaving, setIsSaving] = useState(false);
    const [testResult, setTestResult] = useState<{success: boolean, message: string} | null>(null);
    const [error, setError] = useState('');

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setConfig(prev => ({ ...prev, [name]: value }));
        // Reset test result if user changes config
        setTestResult(null);
    };

    const handleTest = async () => {
        setIsTesting(true);
        setError('');
        setTestResult(null);
        try {
            const msg = await TestDatabaseConfig(config.host, config.port, config.user, config.pass, config.name);
            setTestResult({ success: true, message: msg });
        } catch (err: any) {
            setTestResult({ success: false, message: err.toString() });
        } finally {
            setIsTesting(false);
        }
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!testResult?.success) return;
        
        setIsSaving(true);
        setError('');
        try {
            await SaveDatabaseConfig(config.host, config.port, config.user, config.pass, config.name);
            onConfigured();
        } catch (err: any) {
            setError(err.toString());
        } finally {
            setIsSaving(false);
        }
    };

    return (
        <div className="setup-overlay">
            <div className="card setup-card">
                <div className="setup-header">
                    <div className="logo-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                        </svg>
                    </div>
                    <h2 className="setup-title">Configuração Inicial</h2>
                    <p className="setup-subtitle">Por favor, informe os dados de conexão para continuar.</p>
                </div>

                <form onSubmit={handleSubmit} className="setup-form">
                    <div className="filter-row">
                        <div className="filter-field wide">
                            <label className="field-label">Host do Servidor</label>
                            <input 
                                type="text" 
                                name="host" 
                                value={config.host} 
                                onChange={handleChange} 
                                required
                            />
                        </div>
                        <div className="filter-field">
                            <label className="field-label">Porta</label>
                            <input 
                                type="text" 
                                name="port" 
                                value={config.port} 
                                onChange={handleChange} 
                                required
                            />
                        </div>
                    </div>

                    <div className="filter-row">
                        <div className="filter-field">
                            <label className="field-label">Usuário</label>
                            <input 
                                type="text" 
                                name="user" 
                                value={config.user} 
                                onChange={handleChange} 
                                required
                            />
                        </div>
                        <div className="filter-field">
                            <label className="field-label">Senha</label>
                            <input 
                                type="password" 
                                name="pass" 
                                value={config.pass} 
                                onChange={handleChange}
                            />
                        </div>
                        <div className="filter-field">
                            <label className="field-label">Banco de Dados</label>
                            <input 
                                type="text" 
                                name="name" 
                                value={config.name} 
                                onChange={handleChange} 
                                required
                            />
                        </div>
                    </div>

                    {testResult && (
                        <div className={`test-feedback ${testResult.success ? 'success' : 'fail'}`}>
                            <div className="feedback-icon">
                                {testResult.success ? (
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                ) : (
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                )}
                            </div>
                            <span>{testResult.message}</span>
                        </div>
                    )}

                    {error && <div className="setup-error">{error}</div>}

                    <div className="setup-footer">
                        <button type="button" className="btn btn-ghost" onClick={handleTest} disabled={isTesting || isSaving}>
                            {isTesting ? 'Testando...' : 'Testar Conexão'}
                        </button>
                        <button 
                            type="submit" 
                            className={`btn btn-solid ${!testResult?.success ? 'disabled' : ''}`} 
                            disabled={!testResult?.success || isSaving}
                        >
                            {isSaving ? 'Salvando...' : 'Salvar e Iniciar'}
                        </button>
                    </div>
                </form>
            </div>

            <style>{`
                .setup-overlay {
                    position: fixed; top: 0; left: 0; right: 0; bottom: 0;
                    background: rgba(0, 0, 0, 0.9); backdrop-filter: blur(10px);
                    display: flex; align-items: center; justify-content: center; z-index: 1000; padding: 20px;
                }
                .setup-card { max-width: 650px; width: 100%; border: 1px solid var(--border); }
                .setup-header { text-align: center; margin-bottom: 24px; }
                .setup-title { font-size: 24px; font-weight: 800; margin: 12px 0 4px; }
                .setup-subtitle { font-size: 14px; color: var(--text-secondary); }
                .setup-form { display: flex; flex-direction: column; gap: 16px; }
                
                .test-feedback {
                    display: flex; align-items: center; gap: 10px; padding: 12px 16px; border-radius: var(--radius-md); font-size: 13px; font-weight: 500;
                }
                .test-feedback.success { background: rgba(48, 164, 108, 0.1); color: var(--success); border: 1px solid rgba(48, 164, 108, 0.2); }
                .test-feedback.fail { background: rgba(229, 72, 77, 0.1); color: var(--danger); border: 1px solid rgba(229, 72, 77, 0.2); }
                
                .setup-error { background: rgba(229, 72, 77, 0.1); color: var(--danger); padding: 12px; border-radius: var(--radius-md); font-size: 13px; border: 1px solid rgba(229, 72, 77, 0.2); }
                .setup-footer { margin-top: 16px; display: flex; justify-content: flex-end; gap: 12px; }
                
                .btn.disabled { opacity: 0.5; cursor: not-allowed; filter: grayscale(1); }
            `}</style>
        </div>
    );
}
