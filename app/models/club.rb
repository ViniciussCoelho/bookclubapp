class Club < ApplicationRecord
  def append_message(user_name, message)
    self.chat_messages << {
      user: user_name,
      message: message,
      timestamp: Time.current
    }
    save!
  end
end
