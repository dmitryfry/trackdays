class SimMod < ApplicationRecord
  MOD_TYPES = %w[track car app].freeze

  validates :title, :download_url, presence: true
  validates :mod_type, inclusion: { in: MOD_TYPES }

  scope :tracks, -> { where(mod_type: "track") }
  scope :cars, -> { where(mod_type: "car") }
  scope :apps, -> { where(mod_type: "app") }
end
