import React from 'react';
import { MOCK_RESULTS, MOCK_PILOT, EVENTS } from '../constants';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, ReferenceLine } from 'recharts';
import { Trophy, Timer, TrendingDown } from 'lucide-react';

const Results: React.FC = () => {
  const eventName = EVENTS.find(e => e.id === MOCK_RESULTS.eventId)?.title;
  
  // Prepare data for chart
  const chartData = MOCK_RESULTS.laps
    .filter(l => l.valid)
    .map(l => ({
      session: `Сессия ${l.session}`,
      time: l.lapTime,
    }));

  const bestLap = Math.min(...chartData.map(d => d.time));

  return (
    <div>
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
           <h1 className="text-3xl font-bold text-white">Результаты соревнований</h1>
           <p className="text-slate-400 mt-1">Пилот: {MOCK_PILOT.name} | Событие: {eventName}</p>
        </div>
        <div className="flex items-center gap-4 bg-slate-900 p-3 rounded-lg border border-slate-800">
            <div className="text-right">
                <div className="text-xs text-slate-500 uppercase font-bold">Лучший круг</div>
                <div className="text-xl font-mono text-yellow-500 font-bold">{MOCK_PILOT.bestLap}</div>
            </div>
            <Trophy className="text-yellow-500" size={32} />
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Main Chart */}
        <div className="lg:col-span-2 bg-slate-900 p-6 rounded-xl border border-slate-800">
          <h2 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
            <TrendingDown size={20} className="text-red-500" />
            Прогресс времени круга
          </h2>
          <div className="h-[300px] w-full">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={chartData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#334155" />
                <XAxis dataKey="session" stroke="#94a3b8" />
                <YAxis domain={['auto', 'auto']} stroke="#94a3b8" />
                <Tooltip 
                    contentStyle={{ backgroundColor: '#0f172a', border: '1px solid #1e293b', color: '#f8fafc' }}
                    itemStyle={{ color: '#ef4444' }}
                />
                <ReferenceLine y={bestLap} stroke="green" strokeDasharray="3 3" />
                <Line 
                    type="monotone" 
                    dataKey="time" 
                    stroke="#ef4444" 
                    strokeWidth={3}
                    dot={{ fill: '#ef4444', strokeWidth: 2 }}
                    activeDot={{ r: 8 }} 
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Laptimes Table */}
        <div className="bg-slate-900 p-6 rounded-xl border border-slate-800">
             <h2 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
                <Timer size={20} className="text-blue-500" />
                Детализация
            </h2>
            <div className="overflow-hidden rounded-lg border border-slate-800">
                <table className="w-full text-sm text-left">
                    <thead className="bg-slate-800 text-slate-400">
                        <tr>
                            <th className="px-4 py-3">Сессия</th>
                            <th className="px-4 py-3">Время (сек)</th>
                            <th className="px-4 py-3">Статус</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-800">
                        {MOCK_RESULTS.laps.map((lap) => (
                            <tr key={lap.session} className="hover:bg-slate-800/50 transition-colors">
                                <td className="px-4 py-3 font-medium">#{lap.session}</td>
                                <td className="px-4 py-3 font-mono text-slate-200">{lap.lapTime.toFixed(3)}</td>
                                <td className="px-4 py-3">
                                    {lap.valid ? (
                                        <span className="text-emerald-500 text-xs uppercase font-bold">Valid</span>
                                    ) : (
                                        <span className="text-red-500 text-xs uppercase font-bold">Invalid</span>
                                    )}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
      </div>
    </div>
  );
};

export default Results;