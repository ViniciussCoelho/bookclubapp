class ClubsController < ApplicationController
  before_action :authenticate_user!, except: [:join]
  before_action :set_club, only: [ :show, :edit, :update, :destroy, :update_banner, :send_invitation ]
  before_action :ensure_admin, only: [:edit, :update, :destroy, :update_banner]

  def index
    @clubs = current_user.clubs
  end

  def show
    @messages = @club.chat_messages || []
  end

  def new
    @club = Club.new
  end

  def create
    @club = Club.new(club_params)
    @club.owner_id = current_user.id
    puts "params[:banner]: #{params[:banner]}"
    @club.banner.attach(params[:banner]) if params[:banner].present?

    if @club.save
      ClubUser.create(user: current_user, club: @club, is_admin: true)
      redirect_to @club, notice: "Clube criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @club.update(club_params)
      redirect_to @club, notice: "Clube atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @club.destroy
    redirect_to clubs_path, notice: "Clube excluído com sucesso!"
  end

  def update_banner
    if params[:banner].present?
      @club.banner.attach(params[:banner])

      redirect_to @club, notice: "Banner atualizado com sucesso!"
    else
      redirect_to @club, alert: "Selecione uma imagem para o banner."
    end
  end

  def send_invitation
    if params[:email].present?
      @club.send_invitation(params[:email], current_user, params[:message])
      redirect_to @club, notice: "Convite enviado para #{params[:email]}."
    else
      redirect_to @club, alert: "Informe um email para enviar o convite."
    end
  end

  def join
    @token = params[:token]
    @club = Club.joins(:club_invitations).where(club_invitations: { token: @token }).first
    
    unless @club
      redirect_to root_path, alert: "Convite inválido ou expirado."
      return
    end
    
    unless current_user
      session[:invitation_token] = @token
      redirect_to new_user_session_path, notice: "Faça login ou crie uma conta para aceitar o convite."
      return
    end
    
    if @club.users.include?(current_user)
      redirect_to @club, notice: "Você já é membro deste clube."
      return
    end
    
    invitation = @club.club_invitations.find_by(token: @token)
    
    if invitation.expired?
      redirect_to root_path, alert: "Convite expirado."
      return
    end
    
    if invitation.accepted?
      redirect_to @club, alert: "Este convite já foi utilizado."
      return
    end
  end

  def accept_invitation
    token = params[:token]
    club = Club.joins(:club_invitations).where(club_invitations: { token: token }).first
    
    unless club
      redirect_to root_path, alert: "Convite inválido ou expirado."
      return
    end
    
    if club.accept_invitation(token, current_user)
      redirect_to club, notice: "Bem-vindo ao clube #{club.name}!"
    else
      redirect_to root_path, alert: "Não foi possível aceitar o convite."
    end
  end

  private

  def set_club
    @club = Club.find(params[:id])
  end

  def club_params
    params.require(:club).permit(:name, :description, :banner)
  end

  def ensure_admin
    unless @club.club_users.find_by(user: current_user)&.is_admin
      redirect_to clubs_path, alert: "Você não tem permissão para realizar esta ação."
    end
  end
end
