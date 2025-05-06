class ClubInvitation < ApplicationRecord
  belongs_to :club
  belongs_to :inviter, class_name: 'User', optional: true
  
  before_create :generate_token, :set_expiration
  
  scope :pending, -> { where(accepted_at: nil) }
  scope :valid, -> { where('expires_at > ?', Time.current) }
  
  def expired?
    expires_at < Time.current
  end
  
  def accepted?
    accepted_at.present?
  end
  
  def accept!(user)
    if !expired? && !accepted?
      transaction do
        update!(accepted_at: Time.current)
        club.add_user(user)
      end
      true
    else
      false
    end
  end
  
  private
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64(16)
  end
  
  def set_expiration
    self.expires_at = 7.days.from_now
  end
end 