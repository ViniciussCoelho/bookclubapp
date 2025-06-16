class ReadingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_club
  before_action :set_reading, only: [ :show, :edit, :update, :destroy, :set_as_current ]
  before_action :ensure_admin, except: [ :show ]

  def new
    @reading = @club.readings.build
  end

  def create
    @reading = @club.readings.build(reading_params)

    if @reading.save
      redirect_to @club, notice: "Livro definido com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @reading.update(reading_params)
      redirect_to @club, notice: "Livro atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reading.destroy
    redirect_to @club, notice: "Livro removido com sucesso!"
  end

  def set_as_current
    @club.readings.update_all(current_reading: false)

    @reading.update(current_reading: true)

    redirect_to @club, notice: "Livro definido como atual!"
  end

  private

  def set_club
    @club = Club.find(params[:club_id])
  end

  def set_reading
    @reading = @club.readings.find(params[:id])
  end

  def reading_params
    params.require(:reading).permit(:title, :author, :total_pages, :start_date, :end_date, :current_reading, :description)
  end

  def ensure_admin
    club_user = @club.club_users.find_by(user: current_user)
    unless club_user&.is_admin?
      redirect_to @club, alert: "Apenas administradores podem gerenciar leituras."
    end
  end
end
