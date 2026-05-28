import React from 'react';
import { Activity, Users, Monitor, ShieldCheck } from 'lucide-react';
import { models } from '../../wailsjs/go/models';

interface SummaryCardsProps {
    data: models.Atendimento[];
}

export function SummaryCards({ data }: SummaryCardsProps) {
    const total = data.length;
    
    // Contagem de Analistas Únicos
    const uniqueAnalysts = new Set(data.map(a => a.atendente)).size;
    
    // Contagem de Sistemas Únicos
    const uniqueSystems = new Set(data.map(a => a.sistema)).size;
    
    // Encontrar Categoria Principal
    const categories = data.reduce((acc, curr) => {
        const cat = curr.categoria || 'N/A';
        acc[cat] = (acc[cat] || 0) + 1;
        return acc;
    }, {} as Record<string, number>);
    
    const topCategory = Object.entries(categories).sort((a, b) => b[1] - a[1])[0]?.[0] || 'N/A';

    return (
        <div className="summary-cards">
            <div className="summary-card">
                <div className="card-icon">
                    <Activity size={24} />
                </div>
                <div className="card-info">
                    <span className="card-label">Total Atendimentos</span>
                    <span className="card-value">{total.toLocaleString()}</span>
                </div>
            </div>

            <div className="summary-card">
                <div className="card-icon" style={{ backgroundColor: 'rgba(16, 185, 129, 0.1)', color: '#10b981' }}>
                    <Users size={24} />
                </div>
                <div className="card-info">
                    <span className="card-label">Analistas Ativos</span>
                    <span className="card-value">{uniqueAnalysts}</span>
                </div>
            </div>

            <div className="summary-card">
                <div className="card-icon" style={{ backgroundColor: 'rgba(245, 158, 11, 0.1)', color: '#f59e0b' }}>
                    <Monitor size={24} />
                </div>
                <div className="card-info">
                    <span className="card-label">Sistemas Únicos</span>
                    <span className="card-value">{uniqueSystems}</span>
                </div>
            </div>

            <div className="summary-card">
                <div className="card-icon" style={{ backgroundColor: 'rgba(139, 92, 246, 0.1)', color: '#8b5cf6' }}>
                    <ShieldCheck size={24} />
                </div>
                <div className="card-info">
                    <span className="card-label">Categoria Principal</span>
                    <span className="card-value">{topCategory}</span>
                </div>
            </div>
        </div>
    );
}
