import React from 'react';
import { HashRouter, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Home from './pages/Home';
import Calendar from './pages/Calendar';
import Tracks from './pages/Tracks';
import Results from './pages/Results';
import Wiki from './pages/Wiki';
import Admin from './pages/Admin';

const App: React.FC = () => {
  return (
    <HashRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Home />} />
          <Route path="calendar" element={<Calendar />} />
          <Route path="tracks" element={<Tracks />} />
          <Route path="results" element={<Results />} />
          <Route path="wiki" element={<Wiki />} />
          <Route path="admin" element={<Admin />} />
        </Route>
      </Routes>
    </HashRouter>
  );
};

export default App;