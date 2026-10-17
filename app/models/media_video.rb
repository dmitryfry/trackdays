class MediaVideo < ApplicationRecord
  belongs_to :track, optional: true
  belongs_to :pilot, optional: true

  validates :title, :video_url, presence: true

  scope :onboard_clips, -> { where(category: 'onboard') }
  scope :live_broadcasts, -> { where(category: 'broadcast') }
  scope :tutorials, -> { where(category: 'tutorial') }
end
