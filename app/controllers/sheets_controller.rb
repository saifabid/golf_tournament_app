class SheetsController < ApplicationController
	before_action :check_tournament_organizer_or_admin, only: [:show]

	def show
		get_players
		get_groups
	end

	def edit
		get_players
	end

	def update
	end

	def get_players
		@all_tournament_players = get_tournament_players_list
		print @all_tournament_players
		puts '=========================='
		@group_numbers = {}
		for person in @all_tournament_players
			print person
			puts '=========================='
			@group_numbers[person["player"].group_number] = [Time.now, Time.now]
			puts '=========================='
			puts person["player"].group_number
		end
	end

	def get_groups
		@group_members = []
		Group.where(:tournament_id => params[:id]).each do |group|
			@group_members.append(group.tournament_group_num)
		end
		puts '============================'
		puts @group_members
	end
end
