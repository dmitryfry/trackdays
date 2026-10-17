# Clear existing data in reverse order of dependencies
MarketListing.destroy_all if defined?(MarketListing)
MarketCategory.destroy_all if defined?(MarketCategory)
LogbookEntry.destroy_all if defined?(LogbookEntry)
GarageCar.destroy_all if defined?(GarageCar)
GpsDynoRun.destroy_all
ChampionshipStanding.destroy_all
ChampionshipStage.destroy_all
ChampionshipSeason.destroy_all
Championship.destroy_all
LapResult.destroy_all
TimingSession.destroy_all
Event.destroy_all
Pilot.destroy_all
Team.destroy_all
Track.destroy_all

# 1. Create Tracks
moscow_raceway = Track.create!(
  name: 'Moscow Raceway',
  location: 'Московская обл., Волоколамский р-н',
  length_km: 4.07,
  turns: 15,
  difficulty: 'Профи',
  image_url: 'https://picsum.photos/800/400?random=1',
  description: 'Трасса высшей категории FIA Grade 1. Техничная, с перепадом высот.',
  source_key: 'mrv',
  official_url: 'https://moscowraceway.ru/'
)

igora_drive = Track.create!(
  name: 'Igora Drive',
  location: 'Ленинградская обл., Приозерское ш.',
  length_km: 5.18,
  turns: 20,
  difficulty: 'Профи',
  image_url: 'https://picsum.photos/800/400?random=2',
  description: 'Самый современный автодром в России. Быстрые секции и сложные шпильки.',
  source_key: 'igora',
  official_url: 'https://drive-igora.ru/'
)

adm_raceway = Track.create!(
  name: 'ADM Raceway',
  location: 'Московская обл., Мячково',
  length_km: 3.27,
  turns: 16,
  difficulty: 'Любитель',
  image_url: 'https://picsum.photos/800/400?random=3',
  description: 'Колыбель российского кольца и дрифта.'
)

nring = Track.create!(
  name: 'NRing',
  location: 'Нижний Новгород',
  length_km: 3.22,
  turns: 12,
  difficulty: 'Любитель',
  image_url: 'https://picsum.photos/800/400?random=4',
  description: 'Плоская, но очень быстрая трасса с интересными связками.',
  source_key: 'nring',
  official_url: 'https://nring.ru/'
)

smolensk_ring = Track.create!(
  name: 'Смоленское кольцо',
  location: 'Смоленская обл., Дорогобужский р-н',
  length_km: 3.36,
  turns: 13,
  difficulty: 'Любитель',
  image_url: 'https://picsum.photos/800/400?random=5',
  description: 'Международный автодром под Смоленском. Принимает этапы РСКГ.',
  source_key: 'smolensk',
  official_url: 'https://smolenskring.ru/'
)

kazan_canyon = Track.create!(
  name: 'KazanRing Canyon',
  location: 'Республика Татарстан, Казань',
  length_km: 3.48,
  turns: 14,
  difficulty: 'Любитель',
  image_url: 'https://picsum.photos/800/400?random=6',
  description: 'Горный автодром с перепадом высот.',
  source_key: 'kazan',
  official_url: 'https://kznring.ru/'
)

# 2. Teams
lukoil_racing = Team.create!(
  name: 'LUKOIL Racing Team',
  slug: 'lukoil-racing',
  city: 'Москва',
  description: 'Старейшая и одна из наиболее титулованных профессиональных гоночных команд России.',
  points: 420
)

carville_racing = Team.create!(
  name: 'Carville Racing',
  slug: 'carville-racing',
  city: 'Санкт-Петербург',
  description: 'Заводская гоночная команда производителей автокомпонентов Luzar, Airline, Trialli.',
  points: 385
)

apex_motorsport = Team.create!(
  name: 'Apex Club Motorsport',
  slug: 'apex-motorsport',
  city: 'Москва',
  description: 'Клубная команда энтузиастов Time Attack и длинных гонок.',
  points: 290
)

# 3. Pilots
pilot1 = Pilot.create!(
  team: lukoil_racing,
  name: 'Алексей Дудукало',
  car: 'Audi RS3 LMS TCR',
  pilot_class: 'TCR',
  best_lap: '1:39.812',
  hometown: 'Москва',
  racing_number: 7,
  starts_count: 84,
  wins_count: 32,
  podiums_count: 51,
  points: 215,
  bio: 'Многократный чемпион России по кольцевым гонкам, мастер спорта международного класса.'
)

pilot2 = Pilot.create!(
  team: carville_racing,
  name: 'Григорий Бурлуцкий',
  car: 'Hyundai i30 N TCR',
  pilot_class: 'TCR',
  best_lap: '1:40.104',
  hometown: 'Санкт-Петербург',
  racing_number: 19,
  starts_count: 62,
  wins_count: 14,
  podiums_count: 28,
  points: 170,
  bio: 'Победитель этапов СМП РСКГ Туринг, регулярный призер кубковых гонок.'
)

pilot3 = Pilot.create!(
  team: apex_motorsport,
  name: 'Алексей Петров',
  car: 'Subaru WRX STI Spec-C',
  pilot_class: 'Time Attack Pro',
  best_lap: '1:44.320',
  hometown: 'Москва',
  racing_number: 44,
  starts_count: 28,
  wins_count: 6,
  podiums_count: 12,
  points: 110,
  bio: 'Пилот Time Attack чемпионатов LTAC и Turbo-Pro, активный участник открытых трек-дней.'
)

pilot4 = Pilot.create!(
  team: apex_motorsport,
  name: 'Михаил Степанов',
  car: 'Porsche 911 GT3 (992)',
  pilot_class: 'Supercar',
  best_lap: '1:41.250',
  hometown: 'Казань',
  racing_number: 88,
  starts_count: 35,
  wins_count: 9,
  podiums_count: 18,
  points: 145,
  bio: 'Регулярный участник REC и GT Cup Open.'
)

# 4. Championships & Seasons
rskg = Championship.create!(
  name: 'СМП РСКГ Туринг',
  slug: 'rskg-touring',
  category: 'Кольцевые гонки',
  description: 'Главный чемпионат страны по автомобильным кольцевым гонкам в классах TCR, Супер-Продакшн и Туринг-Лайт.',
  rules_url: 'https://raf-rcrs.ru/documents/'
)

rec = Championship.create!(
  name: 'REC (Russian Endurance Challenge)',
  slug: 'rec-endurance',
  category: 'Гонки на выносливость',
  description: 'Серия 4-часовых гонок на выносливость на главных автодромах страны.',
  rules_url: 'https://rusendurance.com/'
)

ltac = Championship.create!(
  name: 'LTAC (Lap Time Attack Cup)',
  slug: 'ltac-time-attack',
  category: 'Time Attack',
  description: 'Крупнейший любительский и полупрофессиональный кубок на лучшее время круга.',
  rules_url: 'https://ltac.ru/'
)

season_rskg = ChampionshipSeason.create!(
  championship: rskg,
  year: 2026,
  title: 'Сезон 2026'
)

ChampionshipStage.create!([
  { championship_season: season_rskg, track: moscow_raceway, stage_number: 1, date: Date.parse('2026-05-18'), title: 'Гран-При Москвы', status: 'completed' },
  { championship_season: season_rskg, track: smolensk_ring, stage_number: 2, date: Date.parse('2026-06-20'), title: 'Смоленский этап', status: 'completed' },
  { championship_season: season_rskg, track: kazan_canyon, stage_number: 3, date: Date.parse('2026-07-25'), title: 'Казанский каньон', status: 'completed' },
  { championship_season: season_rskg, track: igora_drive, stage_number: 4, date: Date.parse('2026-08-30'), title: 'Кубок Игора Драйв', status: 'upcoming' },
  { championship_season: season_rskg, track: nring, stage_number: 5, date: Date.parse('2026-09-20'), title: 'Нижегородское кольцо', status: 'upcoming' }
])

ChampionshipStanding.create!([
  { championship_season: season_rskg, pilot: pilot1, team: lukoil_racing, racing_class: 'TCR', position: 1, points: 145.0 },
  { championship_season: season_rskg, pilot: pilot2, team: carville_racing, racing_class: 'TCR', position: 2, points: 122.0 },
  { championship_season: season_rskg, pilot: pilot4, team: apex_motorsport, racing_class: 'TCR', position: 3, points: 98.0 }
])

# 5. Timing Sessions & Telemetry
timing_session_live = TimingSession.create!(
  track: moscow_raceway,
  name: 'Трек-день: Быстрая группа (Сессия 4)',
  session_type: 'track_day',
  started_at: Time.current - 20.minutes,
  status: 'live',
  weather_temp: '+23°C',
  track_temp: '+31°C',
  condition: 'Сухо'
)

LapResult.create!([
  { timing_session: timing_session_live, pilot: pilot1, lap_number: 5, lap_time: 99.812, is_valid: true, sector_1_time: 29.120, sector_2_time: 38.250, sector_3_time: 32.442, top_speed: 236.4, gap: 'ЛИДЕР' },
  { timing_session: timing_session_live, pilot: pilot2, lap_number: 6, lap_time: 100.104, is_valid: true, sector_1_time: 29.280, sector_2_time: 38.310, sector_3_time: 32.514, top_speed: 234.1, gap: '+0.292' },
  { timing_session: timing_session_live, pilot: pilot4, lap_number: 4, lap_time: 101.250, is_valid: true, sector_1_time: 29.410, sector_2_time: 38.890, sector_3_time: 32.950, top_speed: 242.8, gap: '+1.438' },
  { timing_session: timing_session_live, pilot: pilot3, lap_number: 7, lap_time: 104.320, is_valid: true, sector_1_time: 30.150, sector_2_time: 40.120, sector_3_time: 34.050, top_speed: 221.5, gap: '+4.508' }
])

# Past session archive
timing_session_past = TimingSession.create!(
  track: igora_drive,
  name: 'Кубок Санкт-Петербурга Квалификация',
  session_type: 'qualifying',
  started_at: 2.days.ago,
  status: 'finished',
  weather_temp: '+19°C',
  track_temp: '+25°C',
  condition: 'Сухо'
)

LapResult.create!([
  { timing_session: timing_session_past, pilot: pilot1, lap_number: 4, lap_time: 122.410, is_valid: true, sector_1_time: 38.2, sector_2_time: 45.1, sector_3_time: 39.11, top_speed: 229.0, gap: 'ЛИДЕР' },
  { timing_session: timing_session_past, pilot: pilot2, lap_number: 5, lap_time: 123.150, is_valid: true, sector_1_time: 38.5, sector_2_time: 45.4, sector_3_time: 39.25, top_speed: 226.5, gap: '+0.740' }
])

# 6. GPSDyno Runs
sample_chart = (100..210).step(10).map.with_index do |spd, idx|
  { "time_s" => (idx * 0.7 + 1.0).round(2), "speed_kmh" => spd, "hp" => (310 + idx * 8 - (idx > 7 ? idx * 5 : 0)) }
end

GpsDynoRun.create!([
  {
    pilot: pilot4,
    title: 'Porsche 911 GT3 (992) Akrapovic Exhaust',
    car_model: 'Porsche 911 GT3',
    car_mass_kg: 1490,
    calculated_hp: 512,
    calculated_torque_nm: 485,
    standard: 'SAE J1349',
    run_date: Date.parse('2026-06-12'),
    chart_data: sample_chart,
    source_file_name: 'Dragy_992GT3_100-200.csv'
  },
  {
    pilot: pilot1,
    title: 'Audi RS3 TCR 2.0 TFSI BoP Setup',
    car_model: 'Audi RS3 LMS',
    car_mass_kg: 1265,
    calculated_hp: 354,
    calculated_torque_nm: 430,
    standard: 'SAE J1349',
    run_date: Date.parse('2026-05-10'),
    chart_data: sample_chart,
    source_file_name: 'RaceChrono_RS3_MRW.csv'
  },
  {
    pilot: pilot3,
    title: 'Subaru Impreza WRX STI Spec-C VF37 Twinscroll',
    car_model: 'Subaru WRX STI',
    car_mass_kg: 1410,
    calculated_hp: 368,
    calculated_torque_nm: 495,
    standard: 'SAE J1349',
    run_date: Date.parse('2026-07-01'),
    chart_data: sample_chart,
    source_file_name: 'Dragy_STI_Pull4th.csv'
  }
])

# 7. Marketplace Categories & Listings
cat_cars = MarketCategory.create!(name: 'Гоночные автомобили (Track-tools)', slug: 'race-cars', position: 1)
cat_rent = MarketCategory.create!(name: 'Аренда спортивной техники', slug: 'rent-cars', position: 2)
cat_parts = MarketCategory.create!(name: 'Запчасти и спортивный тюнинг', slug: 'performance-parts', position: 3)
cat_tires = MarketCategory.create!(name: 'Колеса и шины (слики / полуслики)', slug: 'wheels-and-tires', position: 4)
cat_safety = MarketCategory.create!(name: 'Экипировка и безопасность FIA', slug: 'safety-and-gear', position: 5)
cat_logistics = MarketCategory.create!(name: 'Гоночная логистика и прицепы', slug: 'logistics-and-trailers', position: 6)

car_bmw = GarageCar.find_by(make: 'BMW') || GarageCar.first

MarketListing.create!([
  {
    market_category: cat_cars,
    pilot: pilot4,
    garage_car: car_bmw,
    deal_type: 'sale',
    title: 'Porsche 911 GT3 (992) Clubsport Package',
    description: 'Идеальное состояние. Полный заводской Clubsport пакет: каркас безопасности по приложению FIA, карбоновые ковши, 6-точечные ремни Schroth, система пожаротушения. Обслужена у официального дилера, пробег 12 000 км, 4 трек-дня на Moscow Raceway.',
    price: 24500000,
    city: 'Москва',
    contact_name: 'Михаил Степанов',
    contact_phone: '+7 (916) 111-22-33',
    contact_telegram: 'stepanov_gt3',
    image_url: 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?auto=format&fit=crop&w=1200&q=80'
  },
  {
    market_category: cat_rent,
    pilot: pilot1,
    deal_type: 'rent',
    title: 'Аренда Audi RS3 LMS TCR "Под ключ" на этап РСКГ / трек-день',
    description: 'Боевая техника класса TCR с полной технической поддержкой команды инженеров и механиков. В стоимость аренды входит: доставка на автодром, боевой комплект сликов Yokohama, телеметрия с разбором тренером, топливо.',
    price: 350000,
    price_period: 'per_trackday',
    city: 'Moscow Raceway / Игора Драйв',
    contact_name: 'LUKOIL Racing Customer Service',
    contact_phone: '+7 (495) 777-88-99',
    contact_telegram: 'lukoilracing_rent',
    image_url: 'https://images.unsplash.com/photo-1541348263662-e0c8de4259ba?auto=format&fit=crop&w=1200&q=80'
  },
  {
    market_category: cat_tires,
    pilot: pilot3,
    deal_type: 'sale',
    title: 'Комплект полусликов Nankang AR-1 265/35 R18 (новый)',
    description: 'Новый комплект 4 шт, свежий год выпуска. Идеальный компаунд для сухих сессий Time Attack. Хранение в отапливаемом боксе.',
    price: 98000,
    city: 'Москва',
    contact_name: 'Алексей Петров',
    contact_phone: '+7 (926) 333-44-55',
    contact_telegram: 'petrov_timeattack',
    image_url: 'https://images.unsplash.com/photo-1578844251758-2f71da64c96f?auto=format&fit=crop&w=1200&q=80'
  },
  {
    market_category: cat_safety,
    deal_type: 'want',
    title: 'Куплю гоночный комбинезон OMP / Sparco омологация 8856-2018 (размер 52)',
    description: 'Ищу новый или в отличном состоянии комбинезон для участия в сезоне REC. Желательно темные цвета, действующая омологация FIA.',
    price: 60000,
    city: 'Санкт-Петербург',
    contact_name: 'Дмитрий Гончаров',
    contact_phone: '+7 (981) 555-12-34',
    contact_telegram: 'goncharov_rec',
    image_url: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=1200&q=80'
  }
])

puts "Successfully seeded:"
puts "- #{Track.count} Tracks"
puts "- #{Team.count} Teams"
puts "- #{Pilot.count} Pilots"
puts "- #{Championship.count} Championships (#{ChampionshipSeason.count} seasons, #{ChampionshipStage.count} stages, #{ChampionshipStanding.count} standings)"
puts "- #{TimingSession.count} Timing sessions with #{LapResult.count} lap records"
puts "- #{GpsDynoRun.count} GPSDyno runs"
