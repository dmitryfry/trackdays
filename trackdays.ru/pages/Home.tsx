import React from 'react';
import { Link } from 'react-router-dom';
import { ChevronRight, Calendar, Activity, Zap } from 'lucide-react';

const Home: React.FC = () => {
  return (
    <div className="space-y-12">
      {/* Hero Section */}
      <div className="relative rounded-2xl overflow-hidden bg-slate-900 shadow-2xl border border-slate-800">
        <div className="absolute inset-0 bg-gradient-to-r from-slate-950 via-slate-900/80 to-transparent z-10"></div>
        <img 
          src="https://picsum.photos/1200/600?grayscale" 
          alt="Racing Track" 
          className="absolute inset-0 w-full h-full object-cover opacity-40"
        />
        <div className="relative z-20 p-8 md:p-16 max-w-2xl">
          <h1 className="text-4xl md:text-6xl font-extrabold text-white tracking-tight mb-6">
            Твой путь к <span className="text-red-600">подиуму</span> начинается здесь
          </h1>
          <p className="text-lg text-slate-300 mb-8 leading-relaxed">
            Присоединяйся к сообществу любительского автоспорта. Календарь трек-дней,
            регистрация на события, аналитика кругов и персональный AI тренер.
          </p>
          <div className="flex flex-col sm:flex-row gap-4">
            <Link 
              to="/calendar" 
              className="px-6 py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-lg flex items-center justify-center gap-2 transition-all transform hover:scale-105 shadow-lg shadow-red-900/20"
            >
              <Calendar size={20} />
              Календарь событий
            </Link>
            <Link 
              to="/wiki" 
              className="px-6 py-3 bg-slate-800 hover:bg-slate-700 text-white font-semibold rounded-lg flex items-center justify-center gap-2 transition-all border border-slate-700"
            >
              <Activity size={20} />
              AI Тренер
            </Link>
          </div>
        </div>
      </div>

      {/* Features Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        <div className="bg-slate-900 p-6 rounded-xl border border-slate-800 hover:border-slate-700 transition-colors">
          <div className="w-12 h-12 bg-red-900/20 rounded-lg flex items-center justify-center mb-4">
            <Calendar className="text-red-500" size={24} />
          </div>
          <h3 className="text-xl font-bold text-white mb-2">Единый Календарь</h3>
          <p className="text-slate-400 text-sm">
            Все трек-дни Москвы и Санкт-Петербурга в одном месте. Удобная запись и оплата.
          </p>
        </div>
        <div className="bg-slate-900 p-6 rounded-xl border border-slate-800 hover:border-slate-700 transition-colors">
          <div className="w-12 h-12 bg-blue-900/20 rounded-lg flex items-center justify-center mb-4">
            <Zap className="text-blue-500" size={24} />
          </div>
          <h3 className="text-xl font-bold text-white mb-2">Телеметрия</h3>
          <p className="text-slate-400 text-sm">
            Загружай свои логи, анализируй время круга и сравнивай с соперниками в классе.
          </p>
        </div>
        <div className="bg-slate-900 p-6 rounded-xl border border-slate-800 hover:border-slate-700 transition-colors">
          <div className="w-12 h-12 bg-emerald-900/20 rounded-lg flex items-center justify-center mb-4">
            <Activity className="text-emerald-500" size={24} />
          </div>
          <h3 className="text-xl font-bold text-white mb-2">Вики для Новичков</h3>
          <p className="text-slate-400 text-sm">
            База знаний и AI помощник ответят на вопросы о подготовке авто и технике пилотирования.
          </p>
        </div>
      </div>
    </div>
  );
};

export default Home;