# frozen_string_literal: true

class GpsDynoCalculator
  # Standard air density at sea level, 20°C (kg/m^3)
  AIR_DENSITY = 1.2041
  GRAVITY = 9.80665

  def self.calculate(mass_kg:, points:, frontal_area_m2: 2.1, drag_coefficient: 0.33, rolling_resistance_coeff: 0.015)
    # points: array of { time_s: Float, speed_kmh: Float }
    sorted_points = points.sort_by { |p| p[:time_s] }
    return { hp: 0, torque_nm: 0, chart: [] } if sorted_points.size < 2

    chart = []
    max_power_watts = 0.0

    (1...sorted_points.size).each do |i|
      p0 = sorted_points[i - 1]
      p1 = sorted_points[i]

      dt = p1[:time_s] - p0[:time_s]
      next if dt <= 0.001

      v0 = p0[:speed_kmh] / 3.6 # m/s
      v1 = p1[:speed_kmh] / 3.6 # m/s
      v_avg = (v0 + v1) / 2.0

      acceleration = (v1 - v0) / dt # m/s^2
      next if acceleration < 0 # ignore deceleration

      # Inertial mass including ~8% drivetrain rotational inertia
      effective_mass = mass_kg * 1.08
      f_accel = effective_mass * acceleration
      f_aero = 0.5 * AIR_DENSITY * drag_coefficient * frontal_area_m2 * (v_avg**2)
      f_roll = mass_kg * GRAVITY * rolling_resistance_coeff

      total_force = f_accel + f_aero + f_roll
      power_watts = total_force * v_avg

      # Engine power assuming ~15% drivetrain loss
      crank_power_watts = power_watts / 0.85
      crank_hp = (crank_power_watts / 735.49875).round # Metric HP

      max_power_watts = [max_power_watts, crank_power_watts].max

      chart << {
        time_s: p1[:time_s].round(2),
        speed_kmh: p1[:speed_kmh].round(1),
        hp: crank_hp
      }
    end

    max_hp = (max_power_watts / 735.49875).round
    # Estimated peak torque in Nm (typical turbo/sport ratio ~1.3-1.4x of HP)
    max_torque = (max_hp * 1.35).round

    {
      hp: max_hp,
      torque_nm: max_torque,
      chart: chart
    }
  end

  def self.parse_csv(content)
    points = []
    lines = content.strip.split(/\r?\n/)
    
    # Try detecting Dragy or RaceChrono format
    # Simple parser: look for time and speed columns
    header_idx = lines.find_index { |l| l.downcase.include?("speed") || l.downcase.include?("время") || l.downcase.include?("км/ч") }
    start_line = header_idx ? header_idx + 1 : 0

    lines[start_line..].each do |line|
      parts = line.split(/[;,\t]/).map(&:strip)
      next if parts.size < 2

      # Try parsing first two numeric values
      nums = parts.map { |p| p.tr(",", ".").to_f }.select { |n| n >= 0 }
      next if nums.size < 2

      points << { time_s: nums[0], speed_kmh: nums[1] }
    end

    points
  end
end
