class ClubChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from event_name

    ActionCable.server.broadcast(event_name, {
      message: "Connected",
      user: current_user.id,
      user_email: current_user.email,
      timestamp: Time.current
    })
  end

  def receive(data)
    club = Club.find(params[:club_id])
    club.append_message(current_user.email, data["message"])

    ActionCable.server.broadcast(
      event_name,
      { user: current_user.id, user_email: current_user.email, message: data["message"], timestamp: Time.current }
    )
  end

  private

  def event_name
    "bookclub_development_club_#{params[:club_id]}_chat_channel"
  end
end
