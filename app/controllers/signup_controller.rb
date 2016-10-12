class SignupController < ApplicationController
	def new
	end

	def create

	    @user = User.find(session["warden.user.user.key"][0][0])	

		@tournament_id = Tournament.where("tournaments.name LIKE ?", signup_params[:tournament_name])

		@transaction_num = [@user.id, @tournament_id.first.id, Time.now.to_i]

		@signup = Signup.new({:tournament_id => @tournament_id.first.id,
								:user_id => @user.id,
								:player_tickets => signup_params[:player_tickets],
								:sponsor_tickets => signup_params[:sponsor_tickets],
								:transaction_number => @transaction_num.join.to_i})

		if signup_params[:player_tickets] == ''
			signup_params[:player_tickets] = 0.to_s
		end

		if signup_params[:sponsor_tickets] == ''
			signup_params[:sponsor_tickets] = 0.to_s
		end
		
		if signup_params[:player_tickets] > 0.to_s && signup_params[:sponsor_tickets] > 0.to_s
			@person = Person.find_or_initialize_by(:user_id => @user.id, :tournament_id => @tournament_id.first.id)
			@person.is_player = true
			@person.is_sponsor = true
			@person.save
		elsif signup_params[:player_tickets] > 0.to_s 
			@person = Person.find_or_initialize_by(:user_id => @user.id, :tournament_id => @tournament_id.first.id)
			@person.is_player = true
			@person.save
		elsif signup_params[:sponsor_tickets] > 0.to_s
			@person = Person.find_or_initialize_by(:user_id => @user.id, :tournament_id => @tournament_id.first.id)
			@person.is_sponsor = true
			@person.save
		else
			self.error
		end

		@i = 0

		while @i < signup_params[:sponsor_tickets].to_i do
			@ticket = Ticket.new({:transaction_number => @transaction_num.join.to_i,
									:user_id => @user.id,
									:tournament_id => @tournament_id.first.id,
									:sponsor_ticket => true})

			@ticket.register
			@i += 1

		end

		@i = 0

		while @i < signup_params[:player_tickets].to_i do
			@ticket = Ticket.new({:transaction_number => @transaction_num.join.to_i,
									:user_id => @user.id,
									:tournament_id => @tournament_id.first.id,
									:player_ticket => true})

			@ticket.register
			@i += 1

		end

		return self.error unless @signup.register
	end

	def signup_params
      # fields we want to perform any operations on on in this controller
      params.permit(
          :tournament_name,
          :player_tickets,
          :sponsor_tickets
      )
    end
end
