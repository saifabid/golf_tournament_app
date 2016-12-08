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
		puts @assigned
		@unassigned = @req["values_not_needed"]
		@t_id = @req["t_id"]
		@time = @req["time"]

		@assigned.each do |key, values|
			puts key, values
			@gr = Group.find_by(:tournament_id => @t_id, :tournament_group_num => key)
	
			begin
				@gr.member_one = values[0]
				player = Person.find_by(:id => values[0])
				player.group_number = @gr.id
				player.save
			rescue
				@gr.member_one = -1
			end

			begin
				@gr.member_two = values[1]
				player = Person.find_by(:id => values[1])
				player.group_number = @gr.id
				player.save
			rescue
				@gr.member_two = -1
			end

			begin
				@gr.member_three = values[2]
				player = Person.find_by(:id => values[2])
				player.group_number = @gr.id
				player.save
			rescue
				@gr.member_three = -1
			end

			begin
				@gr.member_four = values[3]
				player = Person.find_by(:id => values[3])
				player.group_number = @gr.id
				player.save
			rescue
				@gr.member_four = -1
			end

			@gr.current_members = values.length
			@gr.start = @time[key]
			@gr.save
			
		end

		@unassigned.each do |key, values|
			begin
				player = Person.find_by(:id => values[0])
				player.group_number = -1
				player.save
			rescue
				player = nil
			end

			begin
				player = Person.find_by(:id => values[1])
				player.group_number = -1
				player.save
			rescue
				player = nil
			end

			begin
				player = Person.find_by(:id => values[2])
				player.group_number = -1
				player.save
			rescue
				player = nil
			end

			begin
				player = Person.find_by(:id => values[3])
				player.group_number = -1
				player.save
			rescue
				player = nil
			end			
		end
	end

	def get_players
		@t_id = params[:id]
		@all_tournament_players = Person.where(tournament_id: @t_id, is_player: true)
		@groups = {}
		Group.where(:tournament_id => @t_id).each do |group|
			begin
				@groups[group.id] = [group.tournament_group_num, group.start.strftime('%H:%M')]
			rescue
				@groups[group.id] = [group.tournament_group_num, "not assigned yet"]
			end
		end
	end
end
