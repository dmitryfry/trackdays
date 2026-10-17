class User < ApplicationRecord
  has_secure_password

  belongs_to :pilot, optional: true
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: %w[pilot track_owner organizer seller spectator] }

  before_validation :normalize_email

  def role_title
    case role
    when "pilot" then "Пилот"
    when "track_owner" then "Владелец автодрома"
    when "organizer" then "Организатор"
    when "seller" then "Продавец"
    else "Зритель / Участник"
    end
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
