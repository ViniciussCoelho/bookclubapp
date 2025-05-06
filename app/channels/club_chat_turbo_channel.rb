class ClubChatTurboChannel < ApplicationCable::Channel
  def subscribed
    if can_access_club?
      stream_from club_stream
    else
      reject
    end
  end

  private

  def can_access_club?
    @club = Club.find(params[:club_id])
    @club.club_users.exists?(user: current_user)
  rescue ActiveRecord::RecordNotFound
    false
  end

  def club_stream
    "club_#{params[:club_id]}_messages"
  end
end
