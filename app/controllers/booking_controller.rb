class BookingController < ApplicationController
  def index
    @slots = SimulatorSlot.active
    @booking = SimBooking.new
  end

  def create
    @booking = SimBooking.new(booking_params)
    if @booking.save
      redirect_to booking_path, notice: "Ваша бронь симулятора успешно подтверждена! Ждем вас в клубе."
    else
      @slots = SimulatorSlot.active
      render :index, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:sim_booking).permit(
      :simulator_slot_id,
      :pilot_id,
      :customer_name,
      :customer_phone,
      :customer_email,
      :booking_date,
      :time_slot,
      :duration_hours,
      :with_instructor,
      :notes
    )
  end
end
