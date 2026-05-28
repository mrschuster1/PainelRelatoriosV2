import React, { useState } from 'react';
import { Lock, User, LogIn, AlertCircle, Layers } from 'lucide-react';
import { Login } from '../../wailsjs/go/main/App';
import './Login.css';

interface LoginScreenProps {
    theme: 'dark' | 'light';
    onToggleTheme: () => void;
    onLoginSuccess: (user: any) => void;
}

export const LoginScreen: React.FC<LoginScreenProps> = ({ theme, onToggleTheme, onLoginSuccess }) => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState<string | null>(null);
    const [isLoading, setIsLoading] = useState(false);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError(null);
        setIsLoading(true);

        try {
            const user = await Login(username, password);
            onLoginSuccess(user);
        } catch (err: any) {
            setError(err || 'Erro ao realizar login. Verifique suas credenciais.');
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className={`login-page ${theme === 'light' ? 'theme-light' : ''}`}>
            <div className="login-background">
                <div className="blob"></div>
                <div className="blob"></div>
                <div className="blob"></div>
            </div>

            <button 
                className="login-theme-toggle" 
                onClick={onToggleTheme}
                title={theme === 'dark' ? "Mudar para tema claro" : "Mudar para tema escuro"}
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
            
            <div className="login-card">
                <div className="login-header">
                    <div className="login-logo">
                        <Layers size={32} color="white" />
                    </div>
                    <h1>Painel Relatórios</h1>
                    <p>Entre com suas credenciais para acessar o painel.</p>
                </div>

                <form className="login-form" onSubmit={handleSubmit} autoComplete="on">
                    {error && (
                        <div className="login-error">
                            <AlertCircle size={18} />
                            <span>{error}</span>
                        </div>
                    )}

                    <div className="form-group">
                        <label htmlFor="username">Usuário</label>
                        <div className="input-wrapper">
                            <User size={18} className="input-icon" />
                            <input
                                id="username"
                                type="text"
                                placeholder="Seu nome de usuário"
                                value={username}
                                onChange={(e) => setUsername(e.target.value)}
                                required
                                autoFocus
                                autoComplete="username"
                            />
                        </div>
                    </div>

                    <div className="form-group">
                        <label htmlFor="password">Senha</label>
                        <div className="input-wrapper">
                            <Lock size={18} className="input-icon" />
                            <input
                                id="password"
                                type="password"
                                placeholder="Sua senha"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                                autoComplete="current-password"
                            />
                        </div>
                    </div>

                    <button 
                        type="submit" 
                        className={`btn-login ${isLoading ? 'loading' : ''}`}
                        disabled={isLoading}
                    >
                        {isLoading ? (
                            <span className="spinner"></span>
                        ) : (
                            <>
                                <LogIn size={20} />
                                <span>Entrar</span>
                            </>
                        )}
                    </button>
                </form>

                <div className="login-footer">
                    <p>&copy; {new Date().getFullYear()} Painel Relatórios. Todos os direitos reservados.</p>
                </div>
            </div>
        </div>
    );
};
