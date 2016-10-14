class SignupController < ApplicationController
	helper_method :assigngroup

	def new
	end


	def assigngroup
		@person = Person.last

		@group = Group.find_or_initialize_by(tournament_id: @person.tournament_id, current_members: 0..3) do |group_work|
			group_work.current_members = 0
			group_work.tournament_id = @person.tournament_id
			group_work.save
		end

		case @group.current_members
		when 0
			@group.member_one = @person.id
			@group.current_members = 1
			@group.save
		when 1
			@group.member_two = @person.id
			@group.current_members = 2
			@group.save
		when 2
			@group.member_three = @person.id
			@group.current_members = 3
			@group.save
		when 3
			@group.member_four = @person.id
			@group.current_members = 4
			@group.save
		else
			puts "!#{@group.current_members}!"
		end

		@person.group_number = @group.id
		@person.save

	end



	def create
	    @tournament_id = Tournament.where("tournaments.name LIKE ?", form_params[:tournament_name])

	    @tournament = Tournament.find_by id: @tournament_id.first.id

	    @transaction_num = [current_user.id, @tournament_id.first.id, Time.now.to_i]

	    if form_params[:player_tickets] == ''
			form_params[:player_tickets] = 0.to_s
		end

		if form_params[:sponsor_level] != "0"
			@ticket_num = [@transaction_num, 1]
			@tournament.person.new(
				:user_id => current_user.id,
				:is_sponsor => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => form_params[:sponsor_level]
				).insert_person
				assigngroup
		else
			@ticket_num = [@transaction_num, 1]
			@tournament.person.new(
				:user_id => current_user.id,
				:is_player => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => form_params[:sponsor_level]
				).insert_person
		end

		@i = 2

		while @i <= form_params[:player_tickets].to_i
			@ticket_num = [@transaction_num, @i]
			@tournament.person.new(
				:guest_of => current_user.id,
				:is_guest => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).insert_person

			@i += 1
		end

		render :new


	end

	def form_params
		params.permit(
			:tournament_name,
			:player_tickets,
			:sponsor_level
			)
	end
end
