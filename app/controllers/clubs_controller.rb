class ClubsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_club, only: [ :show, :edit, :update, :destroy, :update_banner ]

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

  private

  def set_club
    @club = Club.find(params[:id])
  end

  def club_params
    params.require(:club).permit(:name, :description, :banner)
  end
end
