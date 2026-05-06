import { models } from '../../wailsjs/go/models';
import './DataGrid.css';

interface DataGridProps {
    atendimentos: models.Atendimento[];
    isLoading: boolean;
}

export function DataGrid({ atendimentos, isLoading }: DataGridProps) {
    if (isLoading) {
        return <div className="grid-loading">Carregando dados...</div>;
    }

    return (
        <section className="data-grid-container">
            <div className="grid-toolbar">
                <span className="results-count">Exibindo {atendimentos.length} resultados</span>
                <button className="btn-export">Exportar CSV</button>
            </div>
            
            <div className="table-responsive">
                <table className="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Cliente</th>
                            <th>Abertura</th>
                            <th>Fechamento</th>
                            <th>Atendente</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {atendimentos.length === 0 ? (
                            <tr>
                                <td colSpan={6} className="empty-state">Nenhum atendimento encontrado.</td>
                            </tr>
                        ) : (
                            atendimentos.map(item => (
                                <tr key={item.Id}>
                                    <td className="col-id">#{item.Id}</td>
                                    <td className="col-cliente">{item.Cliente}</td>
                                    <td>{new Date(item.DataAbertura).toLocaleString()}</td>
                                    <td>{item.DataFechamento || '-'}</td>
                                    <td>{item.Atendente}</td>
                                    <td>
                                        <span className={`status-badge ${item.Fechado === 'S' ? 'status-closed' : 'status-open'}`}>
                                            {item.Fechado === 'S' ? 'Fechado' : 'Aberto'}
                                        </span>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>
        </section>
    );
}
