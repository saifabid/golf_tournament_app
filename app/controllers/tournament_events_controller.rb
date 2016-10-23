class TournamentEventsController < ApplicationController
  before_action :check_user_auth
  before_action :check_tournament_organizer, only: [:index, :create, :destroy]

  def check_tournament_organizer
    if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:tournament_id])).exists?
     flash[:error] = "Cannot Update Tournament"
     redirect_to "/"
     return
   end
  end

  def index
    @tournament= Tournament.find(params[:tournament_id])
    @tournament.tournament_events.build
  end

  def create
      @tournament= Tournament.find(params[:tournament_id])
      if @tournament.errors.any?
        flash[:error] = @tournament.errors.full_messages.to_sentence
        puts flash[:error]
        render :index
        return
      end

      @tournament_event= @tournament.tournament_events.create(tournament_event_params)
      if @tournament_event.errors.any?
        flash[:error] = @tournament_event.errors.full_messages.to_sentence
        puts flash[:error]
        render :index
        return
      end

      redirect_to tournament_tournament_events_path(@tournament)
  end

  def destroy
    TournamentEvent.find(params[:id]).destroy
    redirect_to tournament_tournament_events_path(Tournament.find(params[:tournament_id]))
  end

  private
  def tournament_event_params
  params.require(:tournament_event).permit(:event_name, :start_time, :end_time, :description)
  end
end
