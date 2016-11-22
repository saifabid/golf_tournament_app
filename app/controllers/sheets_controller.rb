class SheetsController < ApplicationController
  def show
  	@all_tournament_players = get_tournament_players_list
  end

  def update
  end
end
