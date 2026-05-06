import './AboutModal.css';
import iconLogo from '../assets/icon.png';

interface AboutModalProps {
    isOpen: boolean;
    onClose: () => void;
}

export function AboutModal({ isOpen, onClose }: AboutModalProps) {
    if (!isOpen) return null;

    return (
        <div className="modal-overlay about-overlay" onClick={onClose}>
            <div className="modal-content about-content" onClick={e => e.stopPropagation()}>
                <div className="about-header">
                    <img src={iconLogo} alt="App Icon" className="about-logo" />
                    <h2>Painel de Relatórios V2</h2>
                    <p className="version">Versão 2.1.0</p>
                </div>
                
                <div className="about-body">
                    <section>
                        <h3>Sobre o Projeto</h3>
                        <p>
                            Uma ferramenta avançada para análise e exportação de atendimentos, 
                            desenvolvida para proporcionar agilidade e precisão na gestão de dados.
                        </p>
                    </section>

                    <section>
                        <h3>Créditos</h3>
                        <p>
                            Desenvolvido com foco em alta performance e UX premium.
                        </p>
                        <div className="credits-list">
                            <div className="credit-item">
                                <span className="credit-label">Iconografia:</span>
                                <a href="https://icons8.com" target="_blank" rel="noopener noreferrer">Icons8</a>
                            </div>
                        </div>
                    </section>
                </div>

                <div className="about-footer">
                    <button className="btn btn-primary" onClick={onClose}>Fechar</button>
                </div>
            </div>
        </div>
    );
}
