require "test_helper"

class BookingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @slot = SimulatorSlot.create!(
      name: "Static Rig Beta",
      specs: "Fanatec DD2, Pedals V3, Samsung G9 49\"",
      hourly_rate_rub: 1800,
      active: true
    )
  end

  test "should get booking page" do
    get booking_url
    assert_response :success
    assert_select "h1", text: /Онлайн-бронирование симуляторов/
    assert_select "h3", text: @slot.name
  end

  test "should create booking" do
    assert_difference("SimBooking.count") do
      post booking_url, params: {
        sim_booking: {
          simulator_slot_id: @slot.id,
          customer_name: "Иван Петров",
          customer_phone: "+79991234567",
          customer_email: "ivan@example.com",
          booking_date: Date.tomorrow,
          time_slot: "16:00 - 18:00",
          duration_hours: 2,
          with_instructor: "1",
          notes: "Тренировка Смоленского кольца"
        }
      }
    end

    booking = SimBooking.last
    assert_redirected_to booking_path
    assert_equal "Иван Петров", booking.customer_name
    assert_equal 2, booking.duration_hours
    assert_equal true, booking.with_instructor
    assert_equal (1800 * 2) + (1000 * 2), booking.total_price_rub
  end
end
