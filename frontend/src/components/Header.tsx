import './Header.css';

export function Header() {
    return (
        <header className="top-nav-bar">
            <div className="nav-left">
                <div className="search-container hidden-sm">
                    {/* Placeholder for future search */}
                </div>
            </div>
            
            <div className="nav-center">
                <span className="app-title">Helpdesk Analytics</span>
            </div>
            
            <div className="nav-right">
                <div className="avatar-container">
                    {/* Placeholder Avatar */}
                    <div className="avatar">
                        <span className="avatar-initial">U</span>
                    </div>
                </div>
            </div>
        </header>
    );
}
