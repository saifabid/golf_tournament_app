class TournamentStatsController < ApplicationController
  def show
  	# Access info and stats on tournament (ie # of players signed up, amount of revenue generated etc.)
  	# ToDo: Read from signups 
  	@id = params[:id]
  	@tournament_name = Tournament.find(params[:id])
  	@tournament_name = @tournament_name.name
  end
 end
