import './App.css';
import { Header } from './components/Header';

function App() {
    return (
        <div className="app-container">
            <main className="main-content">
                <Header />
                <div className="page-canvas">
                    <div className="page-header">
                        <div>
                            <h1 className="page-title">Busca Avançada de Relatórios</h1>
                            <p className="page-subtitle">Filtre, analise e exporte tickets de atendimento com precisão corporativa.</p>
                        </div>
                    </div>
                    {/* Content will go here */}
                </div>
            </main>
        </div>
    );
}

export default App;
