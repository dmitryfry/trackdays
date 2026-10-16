class GarageController < ApplicationController
  def index
    @cars = GarageCar.includes(:pilot, :logbook_entries)
    @car_of_the_week = GarageCar.car_of_the_week.first || @cars.first

    # Фильтры
    @cars = @cars.where(for_rent: true) if params[:filter] == "rent"
    @cars = @cars.with_onboards if params[:filter] == "onboards"
    @cars = @cars.by_class(params[:car_class]) if params[:car_class].present?

    if params[:sort] == "power"
      @cars = @cars.order(power_hp: :desc)
    elsif params[:sort] == "ratio"
      @cars = @cars.where.not(weight_power_ratio: nil).order(weight_power_ratio: :asc)
    elsif params[:sort] == "weight"
      @cars = @cars.order(mass_kg: :asc)
    else
      @cars = @cars.order(created_at: :desc)
    end
  end

  def show
    @car = GarageCar.includes(:pilot, logbook_entries: [:event, :lap_result, :gps_dyno_run]).find(params[:id])
    @logbook_entries = @car.logbook_entries.recent
    @best_lap = @car.best_lap_time
    @dyno_run = @car.latest_gps_dyno
  end

  def feed
    @entries = LogbookEntry.includes(:garage_car, :event).recent.limit(30)
  end

  def new
    @car = GarageCar.new
  end

  def create
    @car = GarageCar.new(garage_car_params)
    if @car.save
      redirect_to garage_car_path(@car), notice: "Автомобиль успешно добавлен в Гараж!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_logbook_entry
    @car = GarageCar.find(params[:id])
    @entry = @car.logbook_entries.build(logbook_entry_params)
    if @entry.save
      redirect_to garage_car_path(@car), notice: "Запись в бортжурнал добавлена!"
    else
      redirect_to garage_car_path(@car), alert: "Ошибка сохранения записи."
    end
  end

  private

  def garage_car_params
    params.require(:garage_car).permit(:pilot_id, :make, :model, :year, :car_class, :mass_kg, :power_hp, :drivetrain, :specs, :image_url, :for_rent)
  end

  def logbook_entry_params
    params.require(:logbook_entry).permit(:title, :content, :date, :onboard_video_url, :event_id, :lap_result_id, :gps_dyno_run_id)
  end
end
