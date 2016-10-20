require 'pdfkit'
require 'tempfile'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

# TODO: Change name, signup is confusing
class SignupController < ApplicationController
	helper_method :assigngroup, :assignfoursome
  before_action :check_user_auth

	#TODO: Move to helper function
	def download_ticket
		#TODO: User authorization
		@person=Person.find(params[:person_id])
		@tournament=@person.tournament

		ticket_num= @person.ticket_number

		barcode = Barby::Code128B.new(ticket_num)
		blob = Barby::PngOutputter.new(barcode).to_png #Raw PNG data
		tempfile = Tempfile.new([ticket_num.to_s,'.png'], "#{Rails.root.to_s}/tmp/")
		begin
			File.open(tempfile.path, 'wb'){|f| f.write blob }
			html = render_to_string('display_ticket', :locals=>{:person=> @person, :barcode=>tempfile.path, :tournament=> @tournament} , :layout => false)
			pdf = PDFKit.new(html)
			send_data pdf.to_pdf, :filename => 'ticket.pdf',  :type=> 'application/pdf'
		ensure
			tempfile.close
			tempfile.unlink   # deletes the temp file
		end
	end

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

	def assignfoursome
		@person = Person.last(4)

		@group = Group.new(
			:current_members => 4,
			:tournament_id => @person[0].tournament_id,
			:member_one => @person[0].id,
			:member_two => @person[1].id,
			:member_three => @person[2].id,
			:member_four => @person[3].id
		)
		@group.save
		@person[0].group_number = @group.id
		@person[0].save
		@person[1].group_number = @group.id
		@person[1].save
		@person[2].group_number = @group.id
		@person[2].save
		@person[3].group_number = @group.id
		@person[3].save

	end



	def create
	    @tournament_id = Tournament.where("tournaments.name LIKE ?", form_params[:tournament_name])

	    @tournament = Tournament.find_by id: @tournament_id.first.id

	    @transaction_num = [current_user.id, @tournament_id.first.id, Time.now.to_i]

	    if form_params[:player_tickets] == ''
			form_params[:player_tickets] = 0.to_s
		end

		if form_params[:foursome_tickets] == ''
			form_params[:foursome_tickets] = 0.to_s
		end

		@offset = 1
		@player_offset = 0

		if form_params[:sponsor_level].to_i > 0
			@ticket_num = [@transaction_num, @offset]
			@tournament.person.new(
				:user_id => current_user.id,
				:is_sponsor => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => form_params[:sponsor_level]
				).insert_person
			@offset += 1
		end

		if form_params[:foursome_tickets].to_i > 0
			@ticket_num = [@transaction_num, @offset]

			@tournament.person.new(
				:user_id => current_user.id,
				:is_player => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).insert_person

			@l = @offset + 1

			while @l < @offset + 4
				@ticket_num = [@transaction_num, @l]
				@tournament.person.new(
				:guest_of => current_user.id,
				:is_guest => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).insert_person

				@l += 1
			end
			assignfoursome

			@offset += 4

		else	
			@ticket_num = [@transaction_num, @offset]
			@tournament.person.new(
				:user_id => current_user.id,
				:is_player => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).insert_person
			assigngroup
			@player_offset = 1
			@offset += 1

		end

		@k = 1

		while @k < form_params[:foursome_tickets].to_i
			@l = @offset
			while @l < @offset + 4
				@ticket_num = [@transaction_num, @l]
				@tournament.person.new(
				:guest_of => current_user.id,
				:is_guest => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).insert_person

				@l += 1
			end
			assignfoursome
			@k += 1
			@offset += 4
		end

		@i = @offset

		while @i < form_params[:player_tickets].to_i + @offset - @player_offset
			@ticket_num = [@transaction_num, @i]
			@tournament.person.new(
				:guest_of => current_user.id,
				:is_guest => true,
				:transaction_number => @transaction_num.join.to_i,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).insert_person
			assigngroup
			@i += 1
		end

		render :new

	end

	def form_params
		params.permit(
			:foursome_tickets,
			:tournament_name,
			:player_tickets,
			:sponsor_level
			)
	end
end
