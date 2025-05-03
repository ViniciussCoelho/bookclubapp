class ClubChatChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Attempting to subscribe to channel with club_id: #{params[:club_id]}"
    Rails.logger.info "Event name: #{event_name}"

    stream_from event_name
    Rails.logger.info "Successfully subscribed to channel"

    ActionCable.server.broadcast(event_name, {
      message: "New user connected",
      user: current_user.id
    })
  end

  def receive(data)
    Rails.logger.info "Received message: #{data.inspect}"
    club = Club.find(params[:club_id])
    club.append_message(current_user.name, data["message"])

    ActionCable.server.broadcast(
      event_name,
      { user: current_user.name, message: data["message"], timestamp: Time.current }
    )
  end

  private

  def event_name
    "bookclub_development_club_#{params[:club_id]}_chat_channel"
  end
end
