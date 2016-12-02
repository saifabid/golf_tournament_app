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

		@assigned.each do |key, values|
			@gr = Group.find_by(:tournament_id => @t_id, :id => key)
	
			begin
				@gr.member_one = values[0]
				us = Person.find_by(:id => values[0])
				us.group_number = key
				us.save
			rescue
				@gr.member_one = -1
			end

			begin
				@gr.member_two = values[1]
				us = Person.find_by(:id => values[1])
				us.group_number = key
				us.save
			rescue
				@gr.member_two = -1
			end

			begin
				@gr.member_three = values[2]
				us = Person.find_by(:id => values[2])
				us.group_number = key
				us.save
			rescue
				@gr.member_three = -1
			end

			begin
				@gr.member_four = values[3]
				us = Person.find_by(:id => values[3])
				us.group_number = key
				us.save
			rescue
				@gr.member_four = -1
			end

			@gr.current_members = values.length
			@gr.save
			
		end

		@unassigned.each do |key, values|
			begin
				us = Person.find_by(:id => values[0])
				us.group_number = -1
				us.save
			rescue
				us = nil
			end

			begin
				us = Person.find_by(:id => values[1])
				us.group_number = -1
				us.save
			rescue
				us = nil
			end

			begin
				us = Person.find_by(:id => values[2])
				us.group_number = -1
				us.save
			rescue
				us = nil
			end

			begin
				us = Person.find_by(:id => values[3])
				us.group_number = -1
				us.save
			rescue
				us = nil
			end			
		end
	end

	def get_players
		@t_id = params[:id]
		@all_tournament_players = Person.where(tournament_id: params[:id], is_player: true)
		@groups = {}
		Group.where(:tournament_id => params[:id]).each do |group|
			@groups[group.tournament_group_num] = [group.start, group.end]
		end
	end
end
