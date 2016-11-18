class TournamentFeaturesController < ApplicationController
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
    @tournament.tournament_features.build
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

    @tournament_feature= @tournament.tournament_features.create(tournament_event_params)
    if @tournament_feature.errors.any?
      flash[:error] = @tournament_feature.errors.full_messages.to_sentence
      puts flash[:error]
      render :new
      return
    end

    redirect_to new_tournament_tournament_feature_path(@tournament.id)
  end

  def destroy
    TournamentFeature.find(params[:id]).destroy
    redirect_to new_tournament_tournament_feature_path(Tournament.find(params[:tournament_id]))
  end

  private
  def tournament_event_params
    params.require(:tournament_feature).permit(:name, :description)
  end
end
