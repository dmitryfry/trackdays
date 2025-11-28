import React, { useState } from 'react';
import { EVENTS } from '../constants';
import { Plus, Edit, Trash2, Calendar } from 'lucide-react';

const Admin: React.FC = () => {
  // In a real app, this state would come from a backend. 
  // Here we just display the mock data and simulate a form.
  const [events, setEvents] = useState(EVENTS);
  const [isModalOpen, setIsModalOpen] = useState(false);

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold text-white">Панель администратора</h1>
        <button 
            onClick={() => setIsModalOpen(true)}
            className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg flex items-center gap-2 font-medium transition-colors"
        >
            <Plus size={18} /> Создать событие
        </button>
      </div>

      {/* Dashboard Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div className="bg-slate-900 p-4 rounded-xl border border-slate-800">
            <div className="text-slate-500 text-xs font-bold uppercase mb-1">Всего событий</div>
            <div className="text-2xl font-white font-mono">{events.length}</div>
        </div>
        <div className="bg-slate-900 p-4 rounded-xl border border-slate-800">
            <div className="text-slate-500 text-xs font-bold uppercase mb-1">Активных пилотов</div>
            <div className="text-2xl font-white font-mono">142</div>
        </div>
        <div className="bg-slate-900 p-4 rounded-xl border border-slate-800">
            <div className="text-slate-500 text-xs font-bold uppercase mb-1">Выручка (Текущая)</div>
            <div className="text-2xl font-white font-mono text-emerald-500">2.4M ₽</div>
        </div>
      </div>

      {/* Events Table */}
      <div className="bg-slate-900 rounded-xl border border-slate-800 overflow-hidden">
        <div className="p-4 border-b border-slate-800 flex items-center gap-2">
            <Calendar size={20} className="text-slate-400" />
            <h2 className="font-bold text-white">Список Трек-дней</h2>
        </div>
        <div className="overflow-x-auto">
            <table className="w-full text-sm text-left text-slate-300">
                <thead className="text-xs text-slate-400 uppercase bg-slate-950/50">
                    <tr>
                        <th className="px-6 py-3">Дата</th>
                        <th className="px-6 py-3">Название</th>
                        <th className="px-6 py-3">Трасса</th>
                        <th className="px-6 py-3">Слоты</th>
                        <th className="px-6 py-3">Цена</th>
                        <th className="px-6 py-3 text-right">Действия</th>
                    </tr>
                </thead>
                <tbody className="divide-y divide-slate-800">
                    {events.map((event) => (
                        <tr key={event.id} className="hover:bg-slate-800/50">
                            <td className="px-6 py-4">{event.date}</td>
                            <td className="px-6 py-4 font-medium text-white">{event.title}</td>
                            <td className="px-6 py-4">{event.trackId}</td>
                            <td className="px-6 py-4">
                                <span className={event.slotsBooked >= event.slotsTotal ? 'text-red-500' : 'text-emerald-500'}>
                                    {event.slotsBooked}/{event.slotsTotal}
                                </span>
                            </td>
                            <td className="px-6 py-4">{event.priceRub} ₽</td>
                            <td className="px-6 py-4 text-right">
                                <div className="flex justify-end gap-2">
                                    <button className="p-1 hover:text-blue-500 transition-colors"><Edit size={16} /></button>
                                    <button className="p-1 hover:text-red-500 transition-colors"><Trash2 size={16} /></button>
                                </div>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
      </div>

      {/* Mock Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black/80 flex items-center justify-center z-50 p-4">
            <div className="bg-slate-900 rounded-xl border border-slate-700 max-w-md w-full p-6">
                <h3 className="text-xl font-bold text-white mb-4">Новое событие</h3>
                <p className="text-slate-400 mb-6 text-sm">В демо-режиме эта форма не сохраняет данные в базу.</p>
                <div className="space-y-4">
                    <div>
                        <label className="block text-xs font-bold text-slate-400 uppercase mb-1">Название</label>
                        <input type="text" className="w-full bg-slate-950 border border-slate-800 rounded p-2 text-white" />
                    </div>
                    <div>
                        <label className="block text-xs font-bold text-slate-400 uppercase mb-1">Дата</label>
                        <input type="date" className="w-full bg-slate-950 border border-slate-800 rounded p-2 text-white" />
                    </div>
                </div>
                <div className="flex gap-4 mt-8">
                    <button onClick={() => setIsModalOpen(false)} className="flex-1 py-2 bg-slate-800 hover:bg-slate-700 text-white rounded">Отмена</button>
                    <button onClick={() => setIsModalOpen(false)} className="flex-1 py-2 bg-red-600 hover:bg-red-700 text-white rounded">Сохранить</button>
                </div>
            </div>
        </div>
      )}
    </div>
  );
};

export default Admin;