class TournamentTicketsController < ApplicationController
  def index
    @tournament= Tournament.find(params[:tournament_id])
  end
  def create
    @tournament= Tournament.find(params[:tournament_id])
    @tournament_tickets= @tournament.tournament_tickets.create(tournament_ticket_params)
    redirect_to tournament_tournament_tickets_path(@tournament)
  end

  private
  def tournament_ticket_params
    params.require(:tournament_ticket).permit(:ticket_name,:ticket_desc,:ticket_price)
  end
end
