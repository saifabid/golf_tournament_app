class TournamentEventsController < ApplicationController
  before_action :check_user_auth
  def index
    # Determine if this is the owners tournament
    # TODO: Make this a filter method so it can be reused.
    if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:tournament_id])).exists?
     flash[:error] = "Cannot Update Tournament"
     redirect_to "/"
     return
    end
    @tournament= Tournament.find(params[:tournament_id])
    @tournament.tournament_events.build
  end

  def create
      # Determine if the current user has access to this tournament
      if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:tournament_id])).exists?
       flash[:error] = "Cannot Update Tournament"
       redirect_to "/"
       return
      end

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

  private
  def tournament_event_params
  params.require(:tournament_event).permit(:event_name, :start_time, :end_time, :description)
  end
end
