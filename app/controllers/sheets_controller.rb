class SheetsController < ApplicationController
	before_action :check_tournament_organizer_or_admin, only: [:show]

	def show
		get_players
	end

	def edit
		get_players
	end

	def update
	end

	def get_players
		@all_tournament_players = Person.where(tournament_id: params[:id], is_player: true)
		@groups = {}
		Group.where(:tournament_id => params[:id]).each do |group|
			@groups[group.tournament_group_num] = [group.start.strftime("%H:%M"), group.end.strftime("%H:%M")]
		end
		puts '============================'
		puts @groups
	end
end
