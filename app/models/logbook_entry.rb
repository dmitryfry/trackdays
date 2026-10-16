class LogbookEntry < ApplicationRecord
  belongs_to :garage_car
  belongs_to :event, optional: true
  belongs_to :lap_result, optional: true
  belongs_to :gps_dyno_run, optional: true

  validates :title, presence: true

  before_save :detect_video_platform

  scope :recent, -> { order(date: :desc, created_at: :desc) }
  scope :with_video, -> { where.not(onboard_video_url: [nil, ""]) }

  private

  def detect_video_platform
    return if onboard_video_url.blank?

    self.onboard_video_platform = if onboard_video_url.include?("youtube.com") || onboard_video_url.include?("youtu.be")
                                    "youtube"
                                  elsif onboard_video_url.include?("vk.com") || onboard_video_url.include?("vkvideo.ru")
                                    "vk"
                                  elsif onboard_video_url.include?("rutube.ru")
                                    "rutube"
                                  else
                                    "other"
                                  end
  end
end
