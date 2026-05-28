import { Sun, Moon, LogOut, User } from 'lucide-react';

interface HeaderProps {
    theme: 'dark' | 'light';
    onToggleTheme: () => void;
    currentUser: any;
    onLogout: () => void;
}

export function Header({ theme, onToggleTheme, currentUser, onLogout }: HeaderProps) {
    return (
        <header className="top-bar">
            <div className="header-left">
                <div className="breadcrumb">
                    Dashboard / <strong>Relatórios de Atendimento</strong>
                </div>
            </div>
            <div className="header-right">
                {currentUser && (
                    <div className="user-profile">
                        <div className="user-info">
                            <User size={16} className="user-icon" />
                            <span className="user-name">{currentUser.nome}</span>
                        </div>
                        <button 
                            className="logout-btn" 
                            onClick={onLogout}
                            title="Sair"
                        >
                            <LogOut size={18} />
                        </button>
                    </div>
                )}
                <button 
                    className="theme-toggle-btn" 
                    onClick={onToggleTheme}
                    title={theme === 'dark' ? 'Mudar para tema claro' : 'Mudar para tema escuro'}
                >
                    {theme === 'dark' ? <Sun size={18} /> : <Moon size={18} />}
                </button>
            </div>
        </header>
    );
}
