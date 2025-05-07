class ClubChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from event_name
  end

  def receive(data)
    club = Club.find(params[:club_id])
    club.append_message(current_user, data["message"])

    ActionCable.server.broadcast(
      event_name,
      {
        user_id: current_user.id,
        user_name: current_user.email,
        message: data["message"],
        timestamp: Time.current
      }
    )
  end

  private

  def event_name
    "bookclub_#{Rails.env}_club_#{params[:club_id]}_chat_channel"
  end
end
