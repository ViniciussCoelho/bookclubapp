class ClubMessagesController < ApplicationController
  before_action :set_club
  before_action :authenticate_user!

  def create
    messages = @club.chat_messages || []
    messages << {
      "user_id" => current_user.id,
      "user_name" => current_user.email,
      "message" => params[:message],
      "timestamp" => Time.current
    }

    if @club.update(chat_messages: messages)
      ActionCable.server.broadcast(
        "club_#{@club.id}_messages",
        {
          html: render_to_string(
            partial: "clubs/messages",
            locals: {
              messages: messages,
              current_user: current_user
            }
          )
        }
      )
    end

    head :ok
  end

  private

  def set_club
    @club = Club.find(params[:club_id])
  end
end
