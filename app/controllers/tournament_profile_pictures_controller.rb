class TournamentProfilePicturesController < ApplicationController
  before_action :check_user_auth
  before_action :check_tournament_organizer, only: [:index, :create, :destroy]

  def check_tournament_organizer
    if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:tournament_id])).exists?
     flash[:error] = "Cannot Update Tournament"
     redirect_to "/"
     return
   end
  end

  def new
    @tournament= Tournament.find(params[:tournament_id])
    @tournament.tournament_profile_pictures.build
  end

  def index

  end

  def create
    @tournament= Tournament.find(params[:tournament_id])
    if @tournament.errors.any?
      flash[:error] = @tournament.errors.full_messages.to_sentence
      puts flash[:error]
      render :new
      return
    end
   
    params = tournament_profile_picture_params
    uploaded_profile_picture = Image.store(:image, params[:image])
    if uploaded_profile_picture.nil?
      uploaded_profile_picture = {}
    end
    params[:image] = uploaded_profile_picture['url']

    @tournament_profile_picture = @tournament.tournament_profile_pictures.create(params)
    if @tournament_profile_picture.errors.any?
      flash[:error] = @tournament_profile_picture.errors.full_messages.to_sentence
      puts flash[:error]
      render :new
      return
    end

    redirect_to new_tournament_tournament_profile_picture_path(@tournament.id)
  end

  def destroy
    TournamentProfilePicture.find(params[:id]).destroy
    redirect_to new_tournament_tournament_profile_picture_path(Tournament.find(params[:tournament_id]))
  end

  private
  def tournament_profile_picture_params
    params.require(:tournament_profile_picture).permit(:image)
  end
end
