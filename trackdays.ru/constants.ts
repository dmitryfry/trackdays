import { Track, TrackDifficulty, Event, Pilot, SessionResult } from './types';

export const TRACKS: Track[] = [
  {
    id: 'moscow-raceway',
    name: 'Moscow Raceway',
    location: 'Московская обл., Волоколамский р-н',
    lengthKm: 4.07,
    turns: 15,
    difficulty: TrackDifficulty.HARD,
    imageUrl: 'https://picsum.photos/800/400?random=1',
    description: 'Трасса высшей категории FIA Grade 1. Техничная, с перепадом высот.'
  },
  {
    id: 'igora-drive',
    name: 'Igora Drive',
    location: 'Ленинградская обл., Приозерское ш.',
    lengthKm: 5.18,
    turns: 20,
    difficulty: TrackDifficulty.HARD,
    imageUrl: 'https://picsum.photos/800/400?random=2',
    description: 'Самый современный автодром в России. Быстрые секции и сложные шпильки.'
  },
  {
    id: 'adm-raceway',
    name: 'ADM Raceway',
    location: 'Московская обл., Мячково',
    lengthKm: 3.27,
    turns: 16,
    difficulty: TrackDifficulty.MEDIUM,
    imageUrl: 'https://picsum.photos/800/400?random=3',
    description: 'Колыбель российского дрифта и кольцевых гонок. Узкая, затычная трасса.'
  },
  {
    id: 'nring',
    name: 'NRing',
    location: 'Нижний Новгород',
    lengthKm: 3.22,
    turns: 12,
    difficulty: TrackDifficulty.MEDIUM,
    imageUrl: 'https://picsum.photos/800/400?random=4',
    description: 'Плоская, но очень быстрая трасса с интересными связками.'
  }
];

export const EVENTS: Event[] = [
  {
    id: 'evt-1',
    trackId: 'moscow-raceway',
    date: '2024-06-15',
    title: 'TrackRace Days Stage 1',
    slotsTotal: 60,
    slotsBooked: 45,
    priceRub: 15000,
    organizer: 'TrackDays.ru'
  },
  {
    id: 'evt-2',
    trackId: 'igora-drive',
    date: '2024-06-22',
    title: 'Igora Open Track',
    slotsTotal: 80,
    slotsBooked: 78,
    priceRub: 18000,
    organizer: 'Igora Drive'
  },
  {
    id: 'evt-3',
    trackId: 'adm-raceway',
    date: '2024-06-29',
    title: 'Мячково Трек-День',
    slotsTotal: 40,
    slotsBooked: 12,
    priceRub: 8000,
    organizer: 'ADM'
  }
];

export const MOCK_PILOT: Pilot = {
  id: 'user-1',
  name: 'Алексей Петров',
  car: 'Subaru WRX STI',
  class: 'Sport',
  bestLap: '1:54.320'
};

// Mock analytics data for charts
export const MOCK_RESULTS: SessionResult = {
  eventId: 'evt-1',
  pilotId: 'user-1',
  laps: [
    { session: 1, lapTime: 125.5, valid: true },
    { session: 2, lapTime: 122.1, valid: true },
    { session: 3, lapTime: 120.4, valid: true },
    { session: 4, lapTime: 118.8, valid: false }, // off track
    { session: 5, lapTime: 114.3, valid: true },
  ]
};