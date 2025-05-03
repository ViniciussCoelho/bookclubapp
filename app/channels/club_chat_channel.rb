class ClubChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from event_name
    ActionCable.server.broadcast(event_name, {
      message: "New user connected",
      user: current_user.id
    })
  end

  private

  def event_name
    "#{Rails.configuration.action_cable.channel_prefix}_club_#{params[:club_id]}_chat_channel"
  end
end
