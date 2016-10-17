require 'pdfkit'
require 'barby'

# TODO: Change name, signup is confusing
class SignupController < ApplicationController
  before_action :check_user_auth

	#TODO: Move to helper function
	def download_ticket
		@person=Person.find(params[:person_id])
		@tournament=@person.tournament
		html = render_to_string('display_ticket', :locals=>{:person=> @person, :tournament=> @tournament} , :layout => false)
		pdf = PDFKit.new(html)
		send_data(pdf.to_pdf)
	end

	def new
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


	end

	def form_params
		params.permit(
			:tournament_name,
			:player_tickets,
			:sponsor_level
			)
	end
end
