import React, { useState } from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { Flag, Calendar, Trophy, Map, BookOpen, Menu, X, User } from 'lucide-react';

const Layout: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const location = useLocation();

  const navItems = [
    { path: '/', label: 'Главная', icon: <Flag size={18} /> },
    { path: '/calendar', label: 'Календарь', icon: <Calendar size={18} /> },
    { path: '/tracks', label: 'Автодромы', icon: <Map size={18} /> },
    { path: '/results', label: 'Результаты', icon: <Trophy size={18} /> },
    { path: '/wiki', label: 'AI Тренер', icon: <BookOpen size={18} /> },
    { path: '/admin', label: 'Админка', icon: <User size={18} /> },
  ];

  const isActive = (path: string) => location.pathname === path;

  return (
    <div className="min-h-screen flex flex-col bg-slate-950 text-slate-200">
      {/* Navbar */}
      <nav className="sticky top-0 z-50 bg-slate-900/90 backdrop-blur-md border-b border-slate-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center">
              <Link to="/" className="flex items-center gap-2 group">
                <div className="w-8 h-8 bg-gradient-to-br from-red-600 to-red-800 rounded flex items-center justify-center transform group-hover:skew-x-[-10deg] transition-transform">
                  <span className="font-bold text-white italic">T</span>
                </div>
                <span className="font-bold text-xl tracking-tight text-white group-hover:text-red-500 transition-colors">
                  TrackDays<span className="text-red-600">.ru</span>
                </span>
              </Link>
            </div>
            
            {/* Desktop Menu */}
            <div className="hidden md:block">
              <div className="ml-10 flex items-baseline space-x-4">
                {navItems.map((item) => (
                  <Link
                    key={item.path}
                    to={item.path}
                    className={`flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                      isActive(item.path)
                        ? 'bg-red-600/10 text-red-500'
                        : 'text-slate-300 hover:text-white hover:bg-slate-800'
                    }`}
                  >
                    {item.icon}
                    {item.label}
                  </Link>
                ))}
              </div>
            </div>

            {/* Mobile menu button */}
            <div className="md:hidden">
              <button
                onClick={() => setIsMenuOpen(!isMenuOpen)}
                className="inline-flex items-center justify-center p-2 rounded-md text-slate-400 hover:text-white hover:bg-slate-800 focus:outline-none"
              >
                {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
              </button>
            </div>
          </div>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden bg-slate-900 border-b border-slate-800">
            <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
              {navItems.map((item) => (
                <Link
                  key={item.path}
                  to={item.path}
                  onClick={() => setIsMenuOpen(false)}
                  className={`flex items-center gap-3 px-3 py-3 rounded-md text-base font-medium ${
                    isActive(item.path)
                      ? 'bg-red-900/20 text-red-500'
                      : 'text-slate-300 hover:text-white hover:bg-slate-800'
                  }`}
                >
                  {item.icon}
                  {item.label}
                </Link>
              ))}
            </div>
          </div>
        )}
      </nav>

      {/* Main Content */}
      <main className="flex-grow max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Outlet />
      </main>

      {/* Footer */}
      <footer className="bg-slate-900 border-t border-slate-800 py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row justify-between items-center gap-4">
          <div className="text-slate-500 text-sm">
            © 2024 TrackDays.ru. Любительский автоспорт.
          </div>
          <div className="flex gap-6">
            <a href="#" className="text-slate-400 hover:text-white text-sm">Правила</a>
            <a href="#" className="text-slate-400 hover:text-white text-sm">Контакты</a>
            <a href="#" className="text-slate-400 hover:text-white text-sm">Сотрудничество</a>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Layout;