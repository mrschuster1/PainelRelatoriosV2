import { useState, useEffect, useCallback } from 'react';
import './App.css';
import { Header } from './components/Header';
import { FilterPanel, FilterParams } from './components/FilterPanel';
import { DataGrid } from './components/DataGrid';
import { GetAtendimentos } from '../wailsjs/go/main/App';
import { models } from '../wailsjs/go/models';

function App() {
    const [atendimentos, setAtendimentos] = useState<models.Atendimento[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [filters, setFilters] = useState<FilterParams>({
        Fechado: '',
        Atendente: '',
        DataInicio: '',
        DataFim: ''
    });

    const fetchAtendimentos = useCallback(async (currentFilters: FilterParams) => {
        setIsLoading(true);
        try {
            const result = await GetAtendimentos({
                Fechado: currentFilters.Fechado,
                Atendente: currentFilters.Atendente,
                DataInicio: currentFilters.DataInicio,
                DataFim: currentFilters.DataFim
            });
            setAtendimentos(result || []);
        } catch (error) {
            console.error("Failed to fetch atendimentos", error);
        } finally {
            setIsLoading(false);
        }
    }, []);

    useEffect(() => {
        // Initial load
        fetchAtendimentos(filters);
    }, [fetchAtendimentos]);

    const handleFilterChange = (newFilters: FilterParams) => {
        setFilters(newFilters);
        fetchAtendimentos(newFilters);
    };

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
                    
                    <FilterPanel onFilterChange={handleFilterChange} />
                    
                    <DataGrid atendimentos={atendimentos} isLoading={isLoading} />
                </div>
            </main>
        </div>
    );
}

export default App;
