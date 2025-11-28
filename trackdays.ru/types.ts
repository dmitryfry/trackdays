export enum TrackDifficulty {
  EASY = "Новичок",
  MEDIUM = "Любитель",
  HARD = "Профи"
}

export interface Track {
  id: string;
  name: string;
  location: string;
  lengthKm: number;
  turns: number;
  difficulty: TrackDifficulty;
  imageUrl: string;
  description: string;
}

export interface Event {
  id: string;
  trackId: string;
  date: string; // ISO date string
  title: string;
  slotsTotal: number;
  slotsBooked: number;
  priceRub: number;
  organizer: string;
}

export interface Pilot {
  id: string;
  name: string;
  car: string;
  class: 'Street' | 'Sport' | 'Unlim';
  bestLap: string;
}

export interface LapResult {
  session: number;
  lapTime: number; // in seconds
  valid: boolean;
}

export interface SessionResult {
  eventId: string;
  pilotId: string;
  laps: LapResult[];
}