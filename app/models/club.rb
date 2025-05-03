class Club < ApplicationRecord
  has_many :users, through: :club_users
  has_many :club_users
  
  belongs_to :owner, class_name: 'User'

  def append_message(user_name, message)
    self.chat_messages << {
      user: user_name,
      message: message,
      timestamp: Time.current
    }
    save!
  end
end
