import { useState, useEffect, useRef } from 'react';
import './FilterPanel.css';
import DatePicker, { registerLocale } from 'react-datepicker';
import { ptBR } from 'date-fns/locale';
import 'react-datepicker/dist/react-datepicker.css';
import { Calendar } from 'lucide-react';
import { 
    GetSistemas, GetAnalistas, GetCategorias, GetSetores, 
    GetAcoes, GetUnidades, SearchClientes,
    SaveFilterPreset, GetFilterPresets, DeleteFilterPreset
} from '../../wailsjs/go/main/App';

registerLocale('pt-BR', ptBR);

const normalizeString = (str: string) => {
    if (!str) return '';
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
};


export interface FilterParams {
    atendentes: LookupOption[];
    clientes: LookupOption[];
    sistemas: LookupOption[];
    categorias: LookupOption[];
    setores: LookupOption[];
    acoes: LookupOption[];
    unidades: LookupOption[];
    tipoData: string;
    dataInicio: string;
    dataFim: string;
}

interface LookupOption {
    id: string;
    label: string;
}

interface FilterPanelProps {
    initialFilters: FilterParams;
    onFilterChange: (filters: any) => void;
    onStateUpdate?: (filters: FilterParams) => void;
}

interface MultiSelectProps {
    label: string;
    options: LookupOption[];
    selected: LookupOption[];
    onToggle: (opt: LookupOption) => void;
    placeholder?: string;
}

function MultiSelectDropdown({ label, options, selected, onToggle, placeholder = "Todos selecionados" }: MultiSelectProps) {
    const [isOpen, setIsOpen] = useState(false);
    const [searchQuery, setSearchQuery] = useState('');
    const containerRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
                setIsOpen(false);
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    return (
        <div className="filter-field multi-dropdown-field" ref={containerRef}>
            <label className="field-label">{label} ({selected.length})</label>
            <div className="multi-select-trigger" onClick={() => setIsOpen(!isOpen)}>
                <div className="trigger-tags">
                    {selected.length === 0 && <span className="trigger-placeholder">{placeholder}</span>}
                    {selected.map(opt => (
                        <span key={opt.id} className="mini-tag">
                            {opt.label}
                            <button onClick={(e) => { e.stopPropagation(); onToggle(opt); }}>×</button>
                        </span>
                    ))}
                </div>
                <ChevronDown size={14} className={`chevron ${isOpen ? 'open' : ''}`} />
            </div>
            {isOpen && (
                <div className="dropdown-panel">
                    <div className="dropdown-search">
                        <input 
                            type="text" 
                            placeholder="Pesquisar..." 
                            value={searchQuery}
                            onClick={e => e.stopPropagation()}
                            onChange={e => setSearchQuery(e.target.value)}
                        />
                    </div>
                    <div className="dropdown-options">
                        {options.filter(opt => {
                            if (!searchQuery) return true;
                            const searchTerms = normalizeString(searchQuery).trim().split(/\s+/).filter(Boolean);
                            const optLabel = normalizeString(opt.label);
                            return searchTerms.every(term => optLabel.includes(term));
                        }).map(opt => {
                            const isSelected = selected.find(s => s.id === opt.id);
                            return (
                                <div 
                                    key={opt.id} 
                                    className={`dropdown-opt ${isSelected ? 'selected' : ''}`}
                                    onClick={() => onToggle(opt)}
                                >
                                    <div className="checkbox">
                                        {isSelected && <div className="check-mark" />}
                                    </div>
                                    <span>{opt.label}</span>
                                </div>
                            );
                        })}
                    </div>
                </div>
            )}
        </div>
    );
}

import { ChevronDown, Search, Bookmark, Trash2, Plus, Save } from 'lucide-react';

export function FilterPanel({ initialFilters, onFilterChange, onStateUpdate }: FilterPanelProps) {
    const [filters, setFilters] = useState<FilterParams>(initialFilters);

    useEffect(() => {
        if (onStateUpdate) {
            onStateUpdate(filters);
        }
    }, [filters, onStateUpdate]);

    const [options, setOptions] = useState({
        sistemas: [] as LookupOption[],
        analistas: [] as LookupOption[],
        categorias: [] as LookupOption[],
        setores: [] as LookupOption[],
        acoes: [] as LookupOption[],
        unidades: [] as LookupOption[]
    });

    const [clientSearch, setClientSearch] = useState('');
    const [clientResults, setClientResults] = useState<LookupOption[]>([]);
    const [showResults, setShowResults] = useState(false);
    const searchRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const loadOptions = async () => {
            try {
                const [s, a, c, st, ac, u] = await Promise.all([
                    GetSistemas(),
                    GetAnalistas(),
                    GetCategorias(),
                    GetSetores(),
                    GetAcoes(),
                    GetUnidades()
                ]);
                setOptions({
                    sistemas: s || [],
                    analistas: a || [],
                    categorias: c || [],
                    setores: st || [],
                    acoes: ac || [],
                    unidades: u || []
                });
            } catch (err) {
                console.error("Erro ao carregar opções de filtro:", err);
            }
        };
        loadOptions();
    }, []);

    useEffect(() => {
        const timer = setTimeout(async () => {
            if (clientSearch.length > 1) {
                const results = await SearchClientes(clientSearch);
                const filtered = (results || []).filter(r => !filters.clientes.find(c => c.id === r.id));
                setClientResults(filtered);
                setShowResults(true);
            } else {
                setClientResults([]);
                setShowResults(false);
            }
        }, 300);
        return () => clearTimeout(timer);
    }, [clientSearch, filters.clientes]);

    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (searchRef.current && !searchRef.current.contains(event.target as Node)) {
                setShowResults(false);
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    const toggleField = (field: keyof FilterParams, opt: LookupOption) => {
        setFilters(prev => {
            const list = prev[field] as LookupOption[];
            const exists = list.find(c => c.id === opt.id);
            const next = exists 
                ? list.filter(c => c.id !== opt.id)
                : [...list, opt];
            return { ...prev, [field]: next };
        });
    };

    const [presets, setPresets] = useState<{name: string, filters: FilterParams}[]>([]);
    const [presetName, setPresetName] = useState('');

    useEffect(() => {
        loadPresetsFromDB();
    }, []);

    const loadPresetsFromDB = async () => {
        try {
            const saved = await GetFilterPresets();
            if (saved && saved.length > 0) {
                const mappedPresets = saved.map(p => ({
                    name: p.name,
                    filters: JSON.parse(p.filter_json)
                }));
                setPresets(mappedPresets);
            }
        } catch (err) {
            console.error("Erro ao carregar presets do SQLite:", err);
        }
    };

    const savePreset = async () => {
        if (!presetName.trim()) return;
        try {
            await SaveFilterPreset(presetName, formatFilters(filters) as any);
            await loadPresetsFromDB();
            setPresetName('');
        } catch (err) {
            console.error("Erro ao salvar preset no SQLite:", err);
        }
    };

    const loadPreset = (p: {name: string, filters: FilterParams}) => {
        setFilters(p.filters);
        onFilterChange(formatFilters(p.filters));
    };

    const deletePreset = async (name: string) => {
        try {
            await DeleteFilterPreset(name);
            await loadPresetsFromDB();
        } catch (err) {
            console.error("Erro ao deletar preset no SQLite:", err);
        }
    };

    const formatFilters = (f: FilterParams) => {
        return {
            ...f,
            atendentes: f.atendentes.map(o => o.id),
            clientes: f.clientes.map(o => o.id),
            sistemas: f.sistemas.map(o => o.id),
            categorias: f.categorias.map(o => o.id),
            setores: f.setores.map(o => o.id),
            acoes: f.acoes.map(o => o.id),
            unidades: f.unidades.map(o => o.id)
        };
    };

    const handleApply = () => {
        onFilterChange(formatFilters(filters));
    };

    const handleClear = () => {
        const cleared: FilterParams = {
            atendentes: [],
            clientes: [],
            sistemas: [],
            categorias: [],
            setores: [],
            acoes: [],
            unidades: [],
            tipoData: 'Abertura',
            dataInicio: new Date().toISOString().split('T')[0],
            dataFim: new Date().toISOString().split('T')[0]
        };
        setFilters(cleared);
        onFilterChange(formatFilters(cleared));
    };

    return (
        <section className="card filter-card">
            <div className="filter-grid">
                {/* Row 1: Period and Type */}
                <div className="filter-field period-field">
                    <label className="field-label">Tipo de Data</label>
                    <select 
                        name="tipoData" 
                        value={filters.tipoData} 
                        onChange={(e) => setFilters({...filters, tipoData: e.target.value})}
                    >
                        <option value="Abertura">Data de Abertura</option>
                        <option value="Fechamento">Data de Fechamento</option>
                        <option value="Atribuicao">Data de Atribuição</option>
                    </select>
                </div>

                <div className="filter-field period-field">
                    <label className="field-label">Período</label>
                    <div className="date-range-container">
                        <div className="datepicker-wrapper">
                            <DatePicker
                                selected={filters.dataInicio ? new Date(filters.dataInicio + 'T00:00:00') : null}
                                onChange={(date: Date | null) => setFilters({ ...filters, dataInicio: date ? date.toISOString().split('T')[0] : '' })}
                                dateFormat="dd/MM/yyyy"
                                locale="pt-BR"
                                placeholderText="Início"
                                className="custom-datepicker"
                            />
                            <Calendar size={14} className="calendar-icon" />
                        </div>
                        <span className="range-divider">até</span>
                        <div className="datepicker-wrapper">
                            <DatePicker
                                selected={filters.dataFim ? new Date(filters.dataFim + 'T00:00:00') : null}
                                onChange={(date: Date | null) => setFilters({ ...filters, dataFim: date ? date.toISOString().split('T')[0] : '' })}
                                dateFormat="dd/MM/yyyy"
                                locale="pt-BR"
                                placeholderText="Fim"
                                className="custom-datepicker"
                            />
                            <Calendar size={14} className="calendar-icon" />
                        </div>
                    </div>
                </div>

                {/* Clients Search (Multi-select with autocomplete) */}
                <div className="filter-field full-width" ref={searchRef}>
                    <label className="field-label">Clientes Selecionados ({filters.clientes.length})</label>
                    <div className="multi-select-container">
                        <div className="tags-list">
                            {filters.clientes.map(client => (
                                <span key={client.id} className="tag">
                                    {client.label}
                                    <button onClick={() => toggleField('clientes', client)}>×</button>
                                </span>
                            ))}
                        </div>
                        <div className="search-input-wrapper">
                           <Search size={14} className="search-icon-inline" />
                           <input 
                               type="text" 
                               placeholder="Buscar cliente por nome ou ID..."
                               value={clientSearch}
                               onChange={(e) => setClientSearch(e.target.value)}
                               onFocus={() => clientSearch.length > 1 && setShowResults(true)}
                           />
                        </div>
                        {showResults && (
                            <div className="search-results">
                                {clientResults.length > 0 ? (
                                    clientResults.map(opt => (
                                        <div 
                                            key={opt.id} 
                                            className={`result-item ${filters.clientes.find(c => c.id === opt.id) ? 'selected' : ''}`}
                                            onClick={() => {
                                                toggleField('clientes', opt);
                                                setClientSearch('');
                                                setShowResults(false);
                                            }}
                                        >
                                            {opt.label}
                                        </div>
                                    ))
                                ) : (
                                    <div className="result-item disabled">Nenhum cliente encontrado</div>
                                )}
                            </div>
                        )}
                    </div>
                </div>

                {/* Multi-select Dropdowns for other fields */}
                <MultiSelectDropdown 
                    label="Status / Ações"
                    options={options.acoes}
                    selected={filters.acoes}
                    onToggle={(opt) => toggleField('acoes', opt)}
                />

                <MultiSelectDropdown 
                    label="Analistas"
                    options={options.analistas}
                    selected={filters.atendentes}
                    onToggle={(opt) => toggleField('atendentes', opt)}
                />

                <MultiSelectDropdown 
                    label="Sistemas"
                    options={options.sistemas}
                    selected={filters.sistemas}
                    onToggle={(opt) => toggleField('sistemas', opt)}
                />

                <MultiSelectDropdown 
                    label="Categorias"
                    options={options.categorias}
                    selected={filters.categorias}
                    onToggle={(opt) => toggleField('categorias', opt)}
                />

                <MultiSelectDropdown 
                    label="Setores / Células"
                    options={options.setores}
                    selected={filters.setores}
                    onToggle={(opt) => toggleField('setores', opt)}
                />

                <MultiSelectDropdown 
                    label="Unidades"
                    options={options.unidades}
                    selected={filters.unidades}
                    onToggle={(opt) => toggleField('unidades', opt)}
                />
            </div>

            {/* Presets Section */}
            <div className="presets-section">
                <div className="presets-header">
                    <Bookmark size={14} className="header-icon" />
                    <span>Filtros Salvos</span>
                </div>
                
                <div className="presets-container">
                    <div className="presets-list">
                        {presets.map((p, i) => (
                            <div key={i} className="preset-pill">
                                <span className="preset-name" onClick={() => loadPreset(p)}>
                                    {p.name}
                                </span>
                                <button className="btn-delete-preset" onClick={(e) => { e.stopPropagation(); deletePreset(p.name); }} title="Excluir filtro">
                                    <Trash2 size={12} />
                                </button>
                            </div>
                        ))}
                        {presets.length === 0 && <span className="no-presets">Nenhum filtro salvo ainda.</span>}
                    </div>

                    <div className="save-preset-container">
                        <div className="save-input-group">
                            <div className="save-input-wrapper">
                                <Bookmark size={14} className="input-icon" />
                                <input 
                                    type="text" 
                                    placeholder="Nome do novo filtro..." 
                                    value={presetName}
                                    onChange={(e) => setPresetName(e.target.value)}
                                    className="save-preset-input"
                                />
                            </div>
                            <button className="btn-save-action" onClick={savePreset} disabled={!presetName.trim()}>
                                <Plus size={16} />
                                <span>Salvar Filtro</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div className="filter-footer">
                <button className="btn btn-ghost" onClick={handleClear}>
                    Limpar Filtros
                </button>
                <button className="btn btn-solid" onClick={handleApply}>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    Pesquisar Atendimentos
                </button>
            </div>
        </section>
    );
}
