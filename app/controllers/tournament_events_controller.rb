class TournamentEventsController < ApplicationController
  def index
    @tournament= Tournament.find(params[:tournament_id])
  end
  def create
      @tournament= Tournament.find(params[:tournament_id])
      @tournament_event= @tournament.tournament_events.create(tournament_event_params)
      redirect_to tournament_tournament_events_path(@tournament)
  end

  private
  def tournament_event_params
  params.require(:tournament_event).permit(:event_name,:start_time, :end_time)
  end
end
