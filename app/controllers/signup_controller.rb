class SignupController < ApplicationController
	def new
	end

	def create

	    @user = User.find(session["warden.user.user.key"][0][0])	

		@tournament_id = Tournament.where("tournaments.name LIKE ?", signup_params[:tournament_name])

		puts @tournament_id.inspect

		@signup = Signup.new({:tournament_id => @tournament_id.first.id,
								:user_id => @user.id,
								:player_tickets => signup_params[:player_tickets],
								:sponsor_tickets => signup_params[:sponsor_tickets]})

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
