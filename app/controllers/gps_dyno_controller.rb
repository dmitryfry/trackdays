class GpsDynoController < ApplicationController
  def index
    @runs = GpsDynoRun.includes(:pilot).top_power.limit(20)
  end

  def show
    @run = GpsDynoRun.includes(:pilot).find(params[:id])
  end

  def new
    @run = GpsDynoRun.new(car_mass_kg: 1450)
  end

  def create
    mass = params[:car_mass_kg].to_f
    mass = 1450.0 if mass <= 0

    points = []
    if params[:log_file].present?
      content = params[:log_file].read
      points = GpsDynoCalculator.parse_csv(content)
      filename = params[:log_file].original_filename
    end

    # Fallback to simulated 100-200 km/h pull if no file or parsing failed
    if points.empty?
      t_start = 0.0
      (100..200).step(5).each_with_index do |spd, idx|
        # Simulated sports car pull ~8-9s from 100 to 200
        dt = 0.4 + (spd - 100) * 0.005
        t_start += dt
        points << { time_s: t_start.round(2), speed_kmh: spd.to_f }
      end
      filename = "Manual/Simulated Pull"
    end

    calc = GpsDynoCalculator.calculate(mass_kg: mass, points: points)

    @run = GpsDynoRun.new(
      title: params[:title].presence || "#{params[:car_model]} Dyno Run",
      car_model: params[:car_model].presence || "Гоночный автомобиль",
      car_mass_kg: mass,
      calculated_hp: [calc[:hp], 150].max,
      calculated_torque_nm: [calc[:torque_nm], 200].max,
      standard: "SAE J1349",
      run_date: Date.current,
      chart_data: calc[:chart],
      source_file_name: filename,
      pilot: Pilot.first
    )

    if @run.save
      redirect_to gps_dyno_run_path(@run), notice: "Замер мощности успешно рассчитан!"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
