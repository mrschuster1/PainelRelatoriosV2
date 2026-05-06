import React, { useState, useMemo, useEffect, useDeferredValue } from 'react';
import './DataGrid.css';
import {
  useReactTable,
  getCoreRowModel,
  getSortedRowModel,
  getGroupedRowModel,
  getExpandedRowModel,
  getFilteredRowModel,
  ColumnDef,
  flexRender,
  SortingState,
  GroupingState,
  ExpandedState,
} from '@tanstack/react-table';
import { GetHistoricos } from '../../wailsjs/go/main/App';
import { History, X, Minus, Plus, Layers, ArrowUp, ArrowDown, ArrowUpDown, ChevronDown, ChevronRight, Hash } from 'lucide-react';
import { models } from '../../wailsjs/go/models';

interface HistoryModalProps {
  atendimento: models.Atendimento;
  onClose: () => void;
}

function HistoryModal({ atendimento, onClose }: HistoryModalProps) {
  const [historicos, setHistoricos] = useState<models.HistoricoAtendimento[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const load = async () => {
      try {
        const res = await GetHistoricos(atendimento.id);
        setHistoricos(res || []);
      } catch (err) {
        console.error("Erro ao carregar historicos:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [atendimento.id]);

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <h3>Histórico Completo - Atendimento #{atendimento.id}</h3>
          <button className="modal-close" onClick={onClose}><X size={20} /></button>
        </div>
        <div className="modal-body">
          {loading ? (
            <div className="loading-spinner">Carregando históricos...</div>
          ) : historicos.length === 0 ? (
            <div className="empty-history">Nenhum histórico detalhado encontrado.</div>
          ) : (
            <div className="history-list">
              {historicos.map((h, i) => (
                <div key={i} className="history-item">
                  <div className="history-item-header">
                    <span className="history-date">{new Date(h.data).toLocaleDateString('pt-BR')} {h.hora}</span>
                    <span className="history-action">{h.histAcao}</span>
                  </div>
                  <div className="history-item-text">{h.historico}</div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

interface HistoryPreviewProps {
  text: string;
  searchTerm: string;
  highlightText: (text: string, highlight: string) => React.ReactNode;
}

function HistoryPreview({ text, searchTerm, highlightText }: HistoryPreviewProps) {
  const [isExpanded, setIsExpanded] = useState(false);
  const isLongText = text.length > 200;

  return (
    <div className="preview-content">
      <div className="preview-header">
        <div className="preview-label">ÚLTIMO HISTÓRICO:</div>
        {isLongText && (
          <button 
            className="ver-mais-btn"
            onClick={() => setIsExpanded(!isExpanded)}
          >
            {isExpanded ? (
              <><Minus size={12} /> Recolher</>
            ) : (
              <><Plus size={12} /> Ver mais</>
            )}
          </button>
        )}
      </div>
      <div className={`preview-text ${isLongText && !isExpanded ? 'collapsed' : 'expanded'}`}>
        {highlightText(text, searchTerm)}
      </div>
    </div>
  );
}

interface DataGridProps {
  atendimentos: models.Atendimento[];
  isLoading: boolean;
  searchTerm: string;
  setSearchTerm: (val: string) => void;
  showFilters: boolean;
  onToggleFilters: () => void;
  onGroupingChange?: (groupBy: string) => void;
}

const normalizeString = (str: string) => {
  if (!str) return '';
  return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
};

const createAccentRegexPattern = (term: string) => {
  return term
    .replace(/[aáàãâä]/gi, '[aáàãâäAÁÀÃÂÄ]')
    .replace(/[eéèêë]/gi, '[eéèêëEÉÈÊË]')
    .replace(/[iíìîï]/gi, '[iíìîïIÍÌÎÏ]')
    .replace(/[oóòõôö]/gi, '[oóòõôöOÓÒÕÔÖ]')
    .replace(/[uúùûü]/gi, '[uúùûüUÚÙÛÜ]')
    .replace(/[cç]/gi, '[cçCÇ]');
};

function levenshtein(a: string, b: string): number {
  if (a.length === 0) return b.length;
  if (b.length === 0) return a.length;
  
  let prevRow = new Int32Array(b.length + 1);
  for (let j = 0; j <= b.length; j++) prevRow[j] = j;
  let curRow = new Int32Array(b.length + 1);

  for (let i = 1; i <= a.length; i++) {
    curRow[0] = i;
    for (let j = 1; j <= b.length; j++) {
      let cost = a[i - 1] === b[j - 1] ? 0 : 1;
      curRow[j] = Math.min(
        curRow[j - 1] + 1,
        prevRow[j] + 1,
        prevRow[j - 1] + cost
      );
    }
    let temp = prevRow;
    prevRow = curRow;
    curRow = temp;
  }
  return prevRow[b.length];
}

function fuzzyMatchWord(searchWord: string, targetString: string): boolean {
    if (targetString.includes(searchWord)) return true;
    
    // Only apply true fuzzy for words longer than 3 chars to avoid noise
    if (searchWord.length <= 3) return false;
    
    const targetWords = targetString.split(/\s+/);
    const tolerance = searchWord.length >= 6 ? 2 : 1;
    
    for (const tw of targetWords) {
        if (Math.abs(tw.length - searchWord.length) <= tolerance) {
            if (levenshtein(searchWord, tw) <= tolerance) {
                return true;
            }
        }
    }
    return false;
}

export function DataGrid({ 
  atendimentos, 
  isLoading, 
  searchTerm, 
  setSearchTerm,
  showFilters,
  onToggleFilters,
  onGroupingChange
}: DataGridProps) {
  const [sorting, setSorting] = useState<SortingState>([]);
  const [grouping, setGrouping] = useState<GroupingState>([]);
  const [isDragging, setIsDragging] = useState(false);
  const [expanded, setExpanded] = useState<ExpandedState>({});
  const [selectedAtendimento, setSelectedAtendimento] = useState<models.Atendimento | null>(null);
  const [sortByCount, setSortByCount] = useState(false);

  // Use deferred value for the search term to prevent typing lag
  const deferredSearchTerm = useDeferredValue(searchTerm);

  useEffect(() => {
    if (onGroupingChange) {
      onGroupingChange(grouping[0] || '');
    }
  }, [grouping, onGroupingChange]);

  // Helper to highlight search term
  const highlightText = (text: string, highlight: string) => {
    if (!highlight || !highlight.trim()) return text;
    
    // Split the highlight string into individual words
    const terms = highlight.trim().split(/\s+/).filter(Boolean);
    if (terms.length === 0) return text;
    
    // Create a regex that matches any of the words, ignoring accents
    const regexPatterns = terms.map(t => createAccentRegexPattern(t));
    const regex = new RegExp(`(${regexPatterns.join('|')})`, 'gi');
    
    const parts = text.split(regex);
    
    return (
      <span>
        {parts.map((part, i) => {
          const normPart = normalizeString(part);
          const isMatch = terms.some(term => normalizeString(term) === normPart);
          return isMatch ? (
            <mark key={i} className="search-highlight">{part}</mark>
          ) : part;
        })}
      </span>
    );
  };

  const columns = useMemo<ColumnDef<models.Atendimento>[]>(
    () => [
      {
        id: 'historico_full',
        header: 'Histórico',
        size: 85,
        enableGrouping: false,
        cell: (info) => (
          <button 
            className="btn-history-trigger"
            onClick={() => setSelectedAtendimento(info.row.original)}
            title="Ver todos os históricos"
          >
            <History size={16} />
          </button>
        ),
      },
      {
        id: 'cliente',
        accessorKey: 'cliente',
        header: 'Cliente',
        size: 300,
        cell: (info) => (
          <div className="cell-content">
            <span className="main-text">{highlightText(info.getValue() as string, searchTerm)}</span>
            <span className="sub-text">{highlightText(info.row.original.categoria, searchTerm)}</span>
          </div>
        ),
      },
      {
        id: 'pessoa',
        accessorKey: 'pessoa',
        header: 'Pessoa',
        cell: (info) => highlightText(info.getValue() as string, searchTerm),
      },
      {
        id: 'acao',
        accessorKey: 'acao',
        header: 'Ação',
        cell: (info) => highlightText(info.getValue() as string, searchTerm),
      },
      {
        id: 'setor',
        accessorKey: 'setor',
        header: 'Setor',
        cell: (info) => highlightText(info.getValue() as string, searchTerm),
      },
      {
        id: 'sistema',
        accessorKey: 'sistema',
        header: 'Sistema',
        cell: (info) => highlightText(info.getValue() as string, searchTerm),
      },
      {
        id: 'atendente',
        accessorKey: 'atendente',
        header: 'Analista',
        size: 200,
        cell: (info) => highlightText(info.getValue() as string, searchTerm),
      },
      {
        id: 'dataAbertura',
        accessorKey: 'dataAbertura',
        header: 'Abertura',
        size: 130,
        cell: (info) => {
          const dateVal = info.getValue() as string;
          const timeVal = info.row.original.horaAbertura;
          
          if (!dateVal) return '-';
          
          return (
            <div className="cell-content">
              <span className="main-text">{new Date(dateVal).toLocaleDateString('pt-BR')}</span>
              {timeVal && <span className="sub-text">{timeVal.substring(0, 5)}</span>}
            </div>
          );
        },
      },
    ],
    [searchTerm]
  );

  const table = useReactTable({
    data: atendimentos,
    columns,
    state: {
      sorting,
      grouping,
      expanded,
      globalFilter: deferredSearchTerm,
    },
    onSortingChange: setSorting,
    onGroupingChange: setGrouping,
    onExpandedChange: setExpanded,
    columnResizeMode: 'onChange',
    defaultColumn: {
      minSize: 100,
      size: 180,
    },
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getGroupedRowModel: getGroupedRowModel(),
    getExpandedRowModel: getExpandedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    globalFilterFn: (row, _columnId, filterValue: string) => {
      if (!filterValue || !filterValue.trim()) return true;
      
      const searchTerms = normalizeString(filterValue).trim().split(/\s+/).filter(Boolean);
      
      // Combine all relevant fields from the row to allow multi-column matching
      const rowValues = normalizeString([
        row.original.id,
        row.original.cliente,
        row.original.pessoa,
        row.original.categoria,
        row.original.acao,
        row.original.setor,
        row.original.sistema,
        row.original.atendente,
        row.original.historico
      ].join(" "));
      
      // All terms must be found somewhere in the combined row string using fuzzy match
      return searchTerms.every((term: string) => fuzzyMatchWord(term, rowValues));
    },
    sortingFns: {
      groupCount: (rowA, rowB) => {
        const countA = rowA.getIsGrouped() ? rowA.subRows.length : 0;
        const countB = rowB.getIsGrouped() ? rowB.subRows.length : 0;
        
        if (countA !== countB) {
          return countA - countB;
        }
        
        // Fallback to value sorting if counts are equal
        const valA = String(rowA.getValue(rowA.groupingColumnId!)).toLowerCase();
        const valB = String(rowB.getValue(rowB.groupingColumnId!)).toLowerCase();
        return valA.localeCompare(valB);
      }
    }
  });

  // Apply groupCount sorting function to columns if sortByCount is enabled
  useMemo(() => {
    columns.forEach(col => {
      if (col.id !== 'historico_full' && col.id !== 'id') {
        (col as any).sortingFn = sortByCount ? 'groupCount' : 'auto';
      }
    });
  }, [sortByCount, columns]);

  const toggleGroup = (columnId: string) => {
    const column = table.getColumn(columnId);
    if (column && !column.getCanGroup()) return;

    setGrouping((prev) =>
      prev.includes(columnId) ? prev.filter((id) => id !== columnId) : [...prev, columnId]
    );
  };

  const handleDragStart = (e: React.DragEvent, columnId: string) => {
    const column = table.getColumn(columnId);
    if (column && !column.getCanGroup()) {
      e.preventDefault();
      return;
    }

    e.dataTransfer.setData('columnId', columnId);
    e.dataTransfer.effectAllowed = 'move';
    setIsDragging(true);
    
    // Create a ghost image for better UX
    const dragGhost = document.createElement('div');
    dragGhost.className = 'drag-ghost';
    dragGhost.innerText = columns.find(c => c.id === columnId)?.header as string || columnId;
    document.body.appendChild(dragGhost);
    e.dataTransfer.setDragImage(dragGhost, 0, 0);
    setTimeout(() => document.body.removeChild(dragGhost), 0);
  };

  const handleDragEnd = () => {
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    const columnId = e.dataTransfer.getData('columnId');
    const column = table.getColumn(columnId);
    
    if (columnId && column?.getCanGroup() && !grouping.includes(columnId)) {
      setGrouping((prev) => [...prev, columnId]);
    }
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
  };

  return (
    <section className="card grid-card">
      <div className="grid-toolbar-embedded">
        <div className="search-box-embedded">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input 
            type="text" 
            placeholder="Busca rápida nos resultados (Ex: Cliente, Ação...)" 
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        {!showFilters && (
          <div className="filters-collapsed-indicator" onClick={onToggleFilters}>
            <span className="dot"></span>
            Filtros Ativos
          </div>
        )}
      </div>

      {/* cxGrid Style Grouping Panel */}
      <div 
        className={`grouping-panel ${isDragging ? 'dragging' : ''}`}
        onDrop={handleDrop}
        onDragOver={handleDragOver}
      >
        <div className="grouping-info">
          <Layers size={14} />
          <span>Agrupar:</span>
        </div>
        <div className="grouping-tags">
          {grouping.length === 0 && (
            <span className="grouping-placeholder">
              Arraste os cabeçalhos das colunas aqui para agrupar
            </span>
          )}
          {grouping.map((id) => (
            <div key={id} className="group-tag">
              {columns.find((c) => (c as any).accessorKey === id)?.header as string}
              <button onClick={() => toggleGroup(id)}>
                <X size={12} />
              </button>
            </div>
          ))}
        </div>
        {grouping.length > 0 && (
          <div className="grouping-actions">
            <button 
              className={`btn-sort-count ${sortByCount ? 'active' : ''}`}
              onClick={() => setSortByCount(!sortByCount)}
              title="Ordenar grupos pela quantidade de registros"
            >
              <Hash size={14} />
              Ordenar por Count
            </button>
          </div>
        )}
      </div>

      <div className="grid-header">
        <div className="quick-groups">
           <button 
             className={`btn-group ${grouping.includes('cliente') ? 'active' : ''}`}
             onClick={() => toggleGroup('cliente')}
           >
             Cliente
           </button>
           <button 
             className={`btn-group ${grouping.includes('setor') ? 'active' : ''}`}
             onClick={() => toggleGroup('setor')}
           >
             Setor
           </button>
           <button 
             className={`btn-group ${grouping.includes('sistema') ? 'active' : ''}`}
             onClick={() => toggleGroup('sistema')}
           >
             Sistema
           </button>
        </div>
        <div className="grid-summary-badge">
          <span className="summary-label">Total de Atendimentos</span>
          <span className="summary-value">
            {isLoading ? '...' : table.getFilteredRowModel().rows.length}
          </span>
        </div>
      </div>

      <div className="table-wrapper">
        <table className="elegant-table cx-grid">
          <thead>
            {table.getHeaderGroups().map((headerGroup) => (
              <tr key={headerGroup.id}>
                {headerGroup.headers.map((header) => (
                  <th key={header.id} colSpan={header.colSpan} style={{ width: header.getSize() }}>
                    {header.isPlaceholder ? null : (
                      <div className="header-cell-wrapper">
                        {header.column.getCanGroup() && (
                          <div 
                            className="drag-handle"
                            draggable
                            onDragStart={(e) => handleDragStart(e, header.id)}
                            onDragEnd={handleDragEnd}
                          >
                            <Layers size={10} />
                          </div>
                        )}
                        <div
                          className={`header-content ${header.column.getCanSort() ? 'sortable' : ''}`}
                          onClick={header.column.getToggleSortingHandler()}
                        >
                          {flexRender(header.column.columnDef.header, header.getContext())}
                          <span className="sort-icon">
                            {{
                              asc: <ArrowUp size={12} />,
                              desc: <ArrowDown size={12} />,
                            }[header.column.getIsSorted() as string] ?? (
                              header.column.getCanSort() ? <ArrowUpDown size={12} className="opacity-0" /> : null
                            )}
                          </span>
                        </div>
                        {header.column.getCanResize() && (
                          <div
                            {...{
                              onMouseDown: header.getResizeHandler(),
                              onTouchStart: header.getResizeHandler(),
                              className: `resizer ${
                                header.column.getIsResizing() ? 'isResizing' : ''
                              }`,
                            }}
                          />
                        )}
                      </div>
                    )}
                  </th>
                ))}
              </tr>
            ))}
          </thead>
          <tbody>
            {isLoading ? (
              <tr>
                <td colSpan={columns.length} className="loading-skeleton">
                  CARREGANDO DADOS...
                </td>
              </tr>
            ) : table.getRowModel().rows.length === 0 ? (
              <tr>
                <td colSpan={columns.length}>
                  <div className="empty-state-container">
                    <p>Nenhum dado encontrado.</p>
                  </div>
                </td>
              </tr>
            ) : (
              table.getRowModel().rows.map((row) => (
                <React.Fragment key={row.id}>
                  <tr className={row.getIsGrouped() ? 'grouped-row' : ''}>
                    {row.getVisibleCells().map((cell) => (
                      <td key={cell.id}>
                        {cell.getIsGrouped() ? (
                          <button
                            className="group-expand-btn"
                            onClick={row.getToggleExpandedHandler()}
                          >
                            {row.getIsExpanded() ? <ChevronDown size={16} /> : <ChevronRight size={16} />}
                            <span className="group-label">
                              {flexRender(cell.column.columnDef.cell, cell.getContext())} ({row.subRows.length})
                            </span>
                          </button>
                        ) : cell.getIsAggregated() ? (
                          flexRender(
                            cell.column.columnDef.aggregatedCell ?? cell.column.columnDef.cell,
                            cell.getContext()
                          )
                        ) : cell.getIsPlaceholder() ? null : (
                          flexRender(cell.column.columnDef.cell, cell.getContext())
                        )}
                      </td>
                    ))}
                  </tr>
                  {/* Preview Row for Historico */}
                  {!row.getIsGrouped() && row.original.historico && (
                    <tr className="preview-row">
                      <td colSpan={columns.length}>
                        <HistoryPreview 
                          text={row.original.historico} 
                          searchTerm={searchTerm} 
                          highlightText={highlightText}
                        />
                      </td>
                    </tr>
                  )}
                </React.Fragment>
              ))
            )}
          </tbody>
        </table>
      </div>
      {selectedAtendimento && (
        <HistoryModal 
          atendimento={selectedAtendimento} 
          onClose={() => setSelectedAtendimento(null)} 
        />
      )}
    </section>
  );
}
