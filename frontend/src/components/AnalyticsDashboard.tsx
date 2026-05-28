import React, { useMemo } from 'react';
import { models } from '../../wailsjs/go/models';
import './AnalyticsDashboard.css';

interface AnalyticsDashboardProps {
  data: models.Atendimento[];
}

interface DistributionItem {
  label: string;
  count: number;
  percentage: number;
}

export function AnalyticsDashboard({ data }: AnalyticsDashboardProps) {
  const systemDistribution = useMemo(() => {
    const counts: Record<string, number> = {};
    data.forEach(item => {
      const key = item.sistema || 'Não Informado';
      counts[key] = (counts[key] || 0) + 1;
    });

    const total = data.length;
    return Object.entries(counts)
      .map(([label, count]) => ({
        label,
        count,
        percentage: (count / total) * 100
      }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);
  }, [data]);

  const categoryDistribution = useMemo(() => {
    const counts: Record<string, number> = {};
    data.forEach(item => {
      const key = item.categoria || 'Não Informado';
      counts[key] = (counts[key] || 0) + 1;
    });

    const total = data.length;
    return Object.entries(counts)
      .map(([label, count]) => ({
        label,
        count,
        percentage: (count / total) * 100
      }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);
  }, [data]);

  if (data.length === 0) return null;

  return (
    <div className="analytics-dashboard">
      <div className="chart-card">
        <div className="chart-header">
          <h3>Distribuição por Sistema</h3>
        </div>
        <div className="chart-content">
          {systemDistribution.map((item, index) => (
            <div key={item.label} className="chart-row">
              <div className="chart-row-info">
                <span className="chart-label">{item.label}</span>
                <span className="chart-value">{item.count} ({item.percentage.toFixed(1)}%)</span>
              </div>
              <div className="bar-container">
                <div 
                  className="bar-fill" 
                  style={{ width: `${item.percentage}%`, animationDelay: `${index * 0.1}s` }}
                />
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="chart-card">
        <div className="chart-header">
          <h3>Top Categorias</h3>
        </div>
        <div className="chart-content">
          {categoryDistribution.map((item, index) => (
            <div key={item.label} className="chart-row">
              <div className="chart-row-info">
                <span className="chart-label">{item.label}</span>
                <span className="chart-value">{item.count} ({item.percentage.toFixed(1)}%)</span>
              </div>
              <div className="bar-container">
                <div 
                  className="bar-fill" 
                  style={{ 
                    width: `${item.percentage}%`, 
                    animationDelay: `${index * 0.1}s`,
                    background: 'linear-gradient(90deg, var(--secondary), var(--secondary-glow))',
                    boxShadow: '0 0 10px rgba(6, 182, 212, 0.2)'
                  }}
                />
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
