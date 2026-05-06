import iconLogo from '../assets/icon.png';

export function Header() {
    return (
        <header className="top-bar">
            <div className="header-left">
                <img src={iconLogo} alt="Logo" className="header-logo" />
                <div className="breadcrumb">
                    Dashboard / <strong>Relatórios de Atendimento</strong>
                </div>
            </div>
            
        </header>
    );
}
