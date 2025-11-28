import React from 'react';
import { EVENTS, TRACKS } from '../constants';
import { MapPin, Clock, Users, ArrowRight } from 'lucide-react';

const Calendar: React.FC = () => {
  const getTrackName = (id: string) => TRACKS.find(t => t.id === id)?.name || id;

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold text-white">Календарь событий</h1>
        <div className="flex gap-2">
          <select className="bg-slate-900 border border-slate-700 text-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-600">
            <option>Все трассы</option>
            {TRACKS.map(t => <option key={t.id}>{t.name}</option>)}
          </select>
        </div>
      </div>

      <div className="space-y-4">
        {EVENTS.map((event) => (
          <div key={event.id} className="bg-slate-900 rounded-xl border border-slate-800 p-6 hover:border-red-600/50 transition-colors group">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
              <div className="flex-grow">
                <div className="flex items-center gap-3 mb-2">
                  <span className="px-2 py-1 bg-red-900/30 text-red-400 text-xs font-bold rounded uppercase">
                    Track Day
                  </span>
                  <span className="text-slate-400 text-sm flex items-center gap-1">
                    <Clock size={14} />
                    {new Date(event.date).toLocaleDateString('ru-RU', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}
                  </span>
                </div>
                <h3 className="text-xl font-bold text-white mb-1 group-hover:text-red-500 transition-colors">
                  {event.title}
                </h3>
                <div className="flex items-center gap-4 text-sm text-slate-400">
                  <span className="flex items-center gap-1">
                    <MapPin size={14} />
                    {getTrackName(event.trackId)}
                  </span>
                  <span className="flex items-center gap-1">
                    <Users size={14} />
                    {event.slotsBooked} / {event.slotsTotal} мест
                  </span>
                </div>
              </div>

              <div className="flex flex-row md:flex-col items-center md:items-end gap-4 md:gap-1 w-full md:w-auto justify-between">
                 <div className="text-lg font-bold text-emerald-400">
                    {event.priceRub.toLocaleString()} ₽
                 </div>
                 <button className="px-4 py-2 bg-slate-800 hover:bg-red-600 text-white rounded-lg text-sm font-medium transition-colors flex items-center gap-2">
                    Регистрация <ArrowRight size={16} />
                 </button>
              </div>
            </div>
            
            {/* Progress Bar for slots */}
            <div className="mt-4 w-full bg-slate-800 rounded-full h-1.5 overflow-hidden">
              <div 
                className="bg-red-600 h-1.5 rounded-full" 
                style={{ width: `${(event.slotsBooked / event.slotsTotal) * 100}%` }}
              ></div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Calendar;