class Club < ApplicationRecord
  has_many :club_users, dependent: :destroy
  has_many :users, through: :club_users
  
  belongs_to :owner, class_name: 'User'

  has_one_attached :banner

  validates :name, presence: true
  
  # Método auxiliar para obter a URL do banner, caso esteja usando Active Storage
  def banner_url
    if banner.attached?
      Rails.application.routes.url_helpers.rails_blob_url(banner, only_path: true)
    else
      nil
    end
  end
  
  # Adiciona usuário ao clube
  def add_user(user, admin: false)
    club_users.create(user: user, is_admin: admin)
  end

  def append_message(user_name, message)
    self.chat_messages << {
      user: user_name,
      message: message,
      timestamp: Time.current
    }
    save!
  end
end
