# frozen_string_literal: true

module EventSync
  Payload = Struct.new(
    :track_key,
    :title,
    :date,
    :ends_on,
    :kind,
    :price_rub,
    :slots_total,
    :slots_booked,
    :organizer,
    :source_url,
    :external_id,
    keyword_init: true
  ) do
    def source
      track_key
    end

    def valid?
      track_key.present? && title.present? && date.present? && external_id.present?
    end
  end
end
