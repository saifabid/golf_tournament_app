class TournamentStatsController < ApplicationController
  # before_action :check_tournament_organizer

  def show
  	# Access info and stats on tournament (ie # of players signed up, amount of revenue generated etc.)
  	# ToDo: Read from signups 
  	@id = params[:id]
  	@tournament = Tournament.find(params[:id])
  	@tournament_name = @tournament.name

  	@num_checked_in = 0
  	Person.where(tournament_id: @id, checked_in: true).find_each do |person|
  	  @num_checked_in += 1
  	end

  	@player_tickets_left = @tournament.tickets_left
  	@player_tickets_sold = @tournament.total_player_tickets - @player_tickets_left - 4 * @tournament.num_foursomes
    @spectator_tickets_left = @tournament.spectator_tickets_left
    @spectator_tickets_sold = @tournament.total_audience_tickets - @spectator_tickets_left
    @dinner_tickets_left = @tournament.dinner_tickets_left
    @dinner_tickets_sold = @tournament.total_dinner_tickets - @dinner_tickets_left

    #TODO: adjust revenue_players for foursome price
    @revenue_players = @player_tickets_sold * @tournament.player_price
    @revenue_foursomes = @tournament.num_foursomes * @tournament.foursome_price
    @revenue_spectators = @spectator_tickets_sold * @tournament.spectator_price
    @revenue_dinner = @dinner_tickets_sold * @tournament.dinner_price
  	
  	@num_sponsors = 0
    Person.where(tournament_id: @id, is_sponsor: true).find_each do |sponsor|
  	  @num_sponsors += 1
  	end
    @revenue = @revenue_players + @revenue_foursomes + @revenue_spectators + @revenue_dinner

    @potential_revenue_players = @player_tickets_left * @tournament.player_price
    @potential_revenue_spectators = @spectator_tickets_left * @tournament.spectator_price
    @potential_revenue_dinner = @dinner_tickets_left * @tournament.dinner_price
    @potential_revenue = @potential_revenue_players + @potential_revenue_spectators + @potential_revenue_dinner

    @cost = (@tournament.total_player_tickets - @player_tickets_left) * 2.5

    @num_guests = 0
    Person.where(tournament_id: @id, is_guest: true).find_each do |person|
  	  @num_guests += 1
  	end

  end
 end
