# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
Track.destroy_all
Event.destroy_all
Pilot.destroy_all
LapResult.destroy_all

# Create Tracks
moscow_raceway = Track.create!(
  name: 'Moscow Raceway',
  location: 'Московская обл., Волоколамский р-н',
  length_km: 4.07,
  turns: 15,
  difficulty: 'Профи',
  image_url: 'https://picsum.photos/800/400?random=1',
  description: 'Трасса высшей категории FIA Grade 1. Техничная, с перепадом высот.'
)

igora_drive = Track.create!(
  name: 'Igora Drive',
  location: 'Ленинградская обл., Приозерское ш.',
  length_km: 5.18,
  turns: 20,
  difficulty: 'Профи',
  image_url: 'https://picsum.photos/800/400?random=2',
  description: 'Самый современный автодром в России. Быстрые секции и сложные шпильки.'
)

adm_raceway = Track.create!(
  name: 'ADM Raceway',
  location: 'Московская обл., Мячково',
  length_km: 3.27,
  turns: 16,
  difficulty: 'Любитель',
  image_url: 'https://picsum.photos/800/400?random=3',
  description: 'Колыбель российского дрифта и кольцевых гонок. Узкая, затычная трасса.'
)

nring = Track.create!(
  name: 'NRing',
  location: 'Нижний Новгород',
  length_km: 3.22,
  turns: 12,
  difficulty: 'Любитель',
  image_url: 'https://picsum.photos/800/400?random=4',
  description: 'Плоская, но очень быстрая трасса с интересными связками.'
)

# Create Events
event1 = Event.create!(
  track: moscow_raceway,
  date: Date.parse('2024-06-15'),
  title: 'TrackRace Days Stage 1',
  slots_total: 60,
  slots_booked: 45,
  price_rub: 15000,
  organizer: 'TrackDays.ru'
)

event2 = Event.create!(
  track: igora_drive,
  date: Date.parse('2024-06-22'),
  title: 'Igora Open Track',
  slots_total: 80,
  slots_booked: 78,
  price_rub: 18000,
  organizer: 'Igora Drive'
)

event3 = Event.create!(
  track: adm_raceway,
  date: Date.parse('2024-06-29'),
  title: 'Мячково Трек-День',
  slots_total: 40,
  slots_booked: 12,
  price_rub: 8000,
  organizer: 'ADM'
)

# Create Pilot
pilot = Pilot.create!(
  name: 'Алексей Петров',
  car: 'Subaru WRX STI',
  pilot_class: 'Sport',
  best_lap: '1:54.320'
)

# Create Lap Results
LapResult.create!([
  { event: event1, pilot: pilot, session: 1, lap_time: 125.5, is_valid: true },
  { event: event1, pilot: pilot, session: 2, lap_time: 122.1, is_valid: true },
  { event: event1, pilot: pilot, session: 3, lap_time: 120.4, is_valid: true },
  { event: event1, pilot: pilot, session: 4, lap_time: 118.8, is_valid: false },
  { event: event1, pilot: pilot, session: 5, lap_time: 114.3, is_valid: true }
])

puts "Seeded #{Track.count} tracks, #{Event.count} events, #{Pilot.count} pilots, #{LapResult.count} lap results"
