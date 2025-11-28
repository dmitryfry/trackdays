import React from 'react';
import { TRACKS } from '../constants';
import { Map, CornerUpRight, Activity } from 'lucide-react';

const Tracks: React.FC = () => {
  return (
    <div>
      <h1 className="text-3xl font-bold text-white mb-8">Автодромы</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {TRACKS.map((track) => (
          <div key={track.id} className="bg-slate-900 rounded-xl overflow-hidden border border-slate-800 hover:shadow-xl transition-all">
            <div className="h-48 overflow-hidden relative">
              <img 
                src={track.imageUrl} 
                alt={track.name} 
                className="w-full h-full object-cover transition-transform hover:scale-105 duration-700"
              />
              <div className="absolute top-4 right-4 bg-black/70 backdrop-blur-sm px-3 py-1 rounded-full text-xs font-bold text-white border border-white/10">
                {track.difficulty}
              </div>
            </div>
            <div className="p-6">
              <h2 className="text-2xl font-bold text-white mb-2">{track.name}</h2>
              <p className="text-slate-400 text-sm mb-4 flex items-center gap-2">
                <Map size={16} /> {track.location}
              </p>
              
              <div className="grid grid-cols-2 gap-4 mb-4">
                <div className="bg-slate-800/50 p-3 rounded-lg border border-slate-700/50">
                    <div className="text-slate-500 text-xs uppercase font-bold mb-1">Длина</div>
                    <div className="text-white font-mono flex items-center gap-2">
                        <Activity size={14} className="text-red-500" />
                        {track.lengthKm} км
                    </div>
                </div>
                <div className="bg-slate-800/50 p-3 rounded-lg border border-slate-700/50">
                    <div className="text-slate-500 text-xs uppercase font-bold mb-1">Повороты</div>
                    <div className="text-white font-mono flex items-center gap-2">
                        <CornerUpRight size={14} className="text-blue-500" />
                        {track.turns}
                    </div>
                </div>
              </div>

              <p className="text-slate-300 text-sm leading-relaxed mb-4">
                {track.description}
              </p>

              <button className="w-full py-2 bg-slate-800 hover:bg-slate-700 text-white rounded-lg text-sm font-medium transition-colors">
                Показать на карте
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Tracks;