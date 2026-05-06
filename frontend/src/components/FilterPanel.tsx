import { useState } from 'react';
import './FilterPanel.css';

export interface FilterParams {
    Fechado: string;
    Atendente: string;
    DataInicio: string;
    DataFim: string;
}

interface FilterPanelProps {
    onFilterChange: (filters: FilterParams) => void;
}

export function FilterPanel({ onFilterChange }: FilterPanelProps) {
    const [filters, setFilters] = useState<FilterParams>({
        Fechado: '',
        Atendente: '',
        DataInicio: '',
        DataFim: ''
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setFilters(prev => ({ ...prev, [name]: value }));
    };

    const handleApply = () => {
        onFilterChange(filters);
    };

    const handleClear = () => {
        const cleared = { Fechado: '', Atendente: '', DataInicio: '', DataFim: '' };
        setFilters(cleared);
        onFilterChange(cleared);
    };

    return (
        <section className="filter-panel">
            <div className="filter-grid">
                <div className="filter-group date-range-group">
                    <label>Período</label>
                    <div className="date-inputs">
                        <div className="input-wrapper">
                            <input 
                                type="date" 
                                name="DataInicio"
                                value={filters.DataInicio}
                                onChange={handleChange}
                            />
                        </div>
                        <span className="date-separator">ATÉ</span>
                        <div className="input-wrapper">
                            <input 
                                type="date" 
                                name="DataFim"
                                value={filters.DataFim}
                                onChange={handleChange}
                            />
                        </div>
                    </div>
                </div>

                <div className="filter-group">
                    <label>Atendente</label>
                    <input 
                        type="text" 
                        name="Atendente" 
                        placeholder="Nome do atendente"
                        value={filters.Atendente}
                        onChange={handleChange}
                        className="text-input"
                    />
                </div>

                <div className="filter-group">
                    <label>Status</label>
                    <select name="Fechado" value={filters.Fechado} onChange={handleChange}>
                        <option value="">Todos</option>
                        <option value="N">Abertos</option>
                        <option value="S">Fechados</option>
                    </select>
                </div>
            </div>

            <div className="filter-actions">
                <button className="btn-secondary" onClick={handleClear}>
                    Limpar Filtros
                </button>
                <button className="btn-primary" onClick={handleApply}>
                    Aplicar Filtros
                </button>
            </div>
        </section>
    );
}
