class SheetsController < ApplicationController
	before_action :check_tournament_organizer_or_admin, only: [:show]

	def show
		get_players
	end

	def edit
		get_players
	end

	def update
		@req = JSON.parse(request.body.read)
		@assigned = @req["values_needed"]
		@unassigned = @req["values_not_needed"]
		@t_id = @req["t_id"]
		
	end

	def get_players
		@t_id = params[:id]
		@all_tournament_players = Person.where(tournament_id: params[:id], is_player: true)
		@groups = {}
		Group.where(:tournament_id => params[:id]).each do |group|
			@groups[group.tournament_group_num] = [group.start, group.end]
		end
		puts '============================'
		puts @groups
	end
end
