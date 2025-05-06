class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  before_action :check_invitation_after_login
  
  private
  
  def check_invitation_after_login
    return unless current_user && session[:invitation_token].present?
    
    token = session[:invitation_token]
    club = Club.joins(:club_invitations).where(club_invitations: { token: token }).first
    
    if club
      invitation_token = session.delete(:invitation_token)
      
      redirect_to join_clubs_path(token: invitation_token)
    end
  end
end
