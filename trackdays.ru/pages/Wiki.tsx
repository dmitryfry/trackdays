import React, { useState } from 'react';
import { getRacingAdvice } from '../services/geminiService';
import { BookOpen, Send, Bot, Loader, AlertTriangle } from 'lucide-react';

const Wiki: React.FC = () => {
  const [question, setQuestion] = useState('');
  const [answer, setAnswer] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  
  const handleAsk = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!question.trim()) return;

    setLoading(true);
    setAnswer(null);
    const result = await getRacingAdvice(question);
    setAnswer(result);
    setLoading(false);
  };

  const suggestions = [
    "Как правильно проходить апекс?",
    "Какое давление шин выбрать для трека?",
    "Техника торможения Trail-braking",
    "Как подготовить машину к первому трек-дню?"
  ];

  return (
    <div className="max-w-4xl mx-auto">
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-white mb-4 flex items-center justify-center gap-3">
            <Bot size={40} className="text-red-500" />
            AI Гоночный Инженер
        </h1>
        <p className="text-slate-400 text-lg">
            Задай вопрос нашему виртуальному тренеру на базе Gemini. 
            Получи советы по технике пилотирования, настройке авто и безопасности.
        </p>
      </div>

      {/* Chat Interface */}
      <div className="bg-slate-900 rounded-2xl border border-slate-800 shadow-2xl overflow-hidden mb-12">
        <div className="p-6 md:p-8 space-y-6">
            
            {/* Answer Area */}
            {answer && (
                <div className="bg-slate-800/50 rounded-xl p-6 border border-slate-700 animate-fade-in">
                    <div className="flex items-start gap-4">
                        <div className="w-10 h-10 rounded-full bg-emerald-900/50 flex items-center justify-center shrink-0 border border-emerald-500/30">
                            <Bot size={20} className="text-emerald-500" />
                        </div>
                        <div className="prose prose-invert max-w-none">
                            <p className="whitespace-pre-wrap leading-relaxed text-slate-200">{answer}</p>
                        </div>
                    </div>
                </div>
            )}

            {loading && (
                <div className="flex justify-center py-8">
                    <Loader className="animate-spin text-red-500" size={32} />
                </div>
            )}

            {/* Input Area */}
            <form onSubmit={handleAsk} className="relative">
                <input
                    type="text"
                    value={question}
                    onChange={(e) => setQuestion(e.target.value)}
                    placeholder="Спроси, например: 'Что делать при сносе передней оси?'"
                    className="w-full bg-slate-950 border border-slate-700 rounded-xl py-4 pl-6 pr-14 text-white placeholder-slate-500 focus:outline-none focus:border-red-600 focus:ring-1 focus:ring-red-600 transition-all shadow-inner"
                />
                <button 
                    type="submit"
                    disabled={loading || !question}
                    className="absolute right-2 top-2 bottom-2 bg-red-600 hover:bg-red-700 disabled:bg-slate-800 disabled:text-slate-600 text-white p-2 rounded-lg transition-colors"
                >
                    <Send size={20} />
                </button>
            </form>

            {/* Suggestions */}
            {!answer && !loading && (
                 <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    {suggestions.map((s) => (
                        <button
                            key={s}
                            onClick={() => setQuestion(s)}
                            className="text-left p-3 rounded-lg border border-slate-800 hover:bg-slate-800 hover:border-slate-700 text-sm text-slate-400 hover:text-white transition-colors flex items-center gap-2"
                        >
                            <BookOpen size={16} className="shrink-0" />
                            {s}
                        </button>
                    ))}
                 </div>
            )}
        </div>
        
        <div className="bg-slate-950 px-6 py-4 border-t border-slate-800 flex items-center gap-2 text-xs text-yellow-600/80">
            <AlertTriangle size={14} />
            AI может совершать ошибки. Всегда следуйте указаниям маршалов на трассе и здравому смыслу.
        </div>
      </div>

      {/* Static Wiki Categories */}
      <h2 className="text-2xl font-bold text-white mb-6">База Знаний</h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {['Флаги и сигналы', 'Подготовка авто', 'Траектории'].map((cat, i) => (
            <div key={i} className="bg-slate-900 p-6 rounded-xl border border-slate-800 hover:border-red-500/50 transition-colors cursor-pointer group">
                <h3 className="font-bold text-lg text-white group-hover:text-red-500 transition-colors">{cat}</h3>
                <p className="text-slate-500 text-sm mt-2">Читать раздел &rarr;</p>
            </div>
        ))}
      </div>
    </div>
  );
};

export default Wiki;