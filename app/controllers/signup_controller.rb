require 'pdfkit'
require 'tempfile'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

# TODO: Change name, signup is confusing
class SignupController < ApplicationController
	helper_method :assigngroup, :assignfoursome
  before_action :check_user_auth
	before_action :check_number_tickets, only: [:create]
  before_action :check_positive_amounts, only: [:create]

	#TODO: place in helper class
	def generate_barcode_img(numtoCode)
		barcode = Barby::Code128B.new(numtoCode)
		png = Barby::PngOutputter.new(barcode).to_png #Raw PNG data
		return png
	end

	def generate_ticket_pdf(personid)
	@person=Person.find(personid)
	@tournament=@person.tournament

	ticket_num= @person.ticket_number
	barcodepng= generate_barcode_img(ticket_num)
	tempbarcode=Tempfile.new([ticket_num.to_s, '.png'], "#{Rails.root.to_s}/tmp/")

	begin
		File.open(tempbarcode.path, 'wb') { |f| f.write barcodepng }
		# do something with image
		html = render_to_string('display_ticket', :locals => {:person => @person, :barcode => tempbarcode.path, :tournament => @tournament}, :layout => false)
		pdf = PDFKit.new(html).to_pdf
		return pdf
	ensure
		tempbarcode.close
		tempbarcode.unlink
	end
	end

	def download_ticket
		person_id= params[:person_id]
		pdf= generate_ticket_pdf(person_id)
		 send_data pdf, type:'application/pdf',  disposition: 'attachment', filename:'ticket.pdf'
end
	def signup_summary
		transaction_id= params[:transaction_id]
		transaction= TicketTransaction.find(transaction_id)
		if(transaction.user_id!= current_user.id)
			raise 'You are not permitted to view this transaction'
		end
		@transaction_num = transaction.transaction_number
		people= Person.where(:ticket_transaction_id=> transaction_id)
		@tickets= people.where('is_guest= 1 OR is_player = 1 OR is_sponsor= 1')

	end


	def new
    flash[:error] = ""
    @tournament = Tournament.first
  end

  def signup_from_tournament
    @tournament = Tournament.where("tournaments.id LIKE ?", params[:id]).first
    params[:tournament_name] = @tournament.name
  end

	def index
		redirect_to "/signup/new"
	end

	def check_number_tickets

		@total_tickets =  params[:player_tickets].to_i + 4*params[:foursome_tickets].to_i

		@tournament_id = Tournament.where("tournaments.name LIKE ?", params[:tournament_name])

		@tournament = Tournament.find_by id: @tournament_id.first.id

		if @total_tickets > @tournament.tickets_left.to_i
			flash[:error] = "You have selected more tickets than what's available"
			render :new
			return
		else
			flash[:error] = ""
		end

		@total_spectator_tickets =  params[:spectator_tickets].to_i

		if @total_spectator_tickets > @tournament.spectator_tickets_left.to_i
			flash[:error] = "You have selected more tickets than what's available"
			render :new
			return
		else
			flash[:error] = ""
		end

	end

	def check_positive_amounts

    if params[:player_tickets] != "" && params[:player_tickets].to_i < 0
      flash[:error] = "Negative"
      render :new
    end

    if params[:foursome_tickets] != "" && params[:foursome_tickets].to_i < 0
      flash[:error] = "Negative"
      render :new
		end

		if params[:spectator_tickets] != "" && params[:spectator_tickets].to_i < 0
			flash[:error] = "Negative"
			render :new
		end

  end

	def assigngroup
		@person = Person.last
		@tournament_num = Group.where(sprintf("tournament_id = %d AND tournament_group_num IS NOT NULL", @person.tournament_id)).last

    @num = 0

    if @tournament_num.nil? || @tournament_num.tournament_group_num.nil?
      @num = 1
		else
      @num = @tournament_num.tournament_group_num
      @num += 1
    end

		@group = Group.find_or_initialize_by(tournament_id: @person.tournament_id, current_members: 0..3) do |group_work|
			group_work.tournament_group_num = @num
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

		@tournament_num = Group.where(sprintf("tournament_id = %d AND tournament_group_num IS NOT NULL", @person[0].tournament_id)).last

		@num = 0

		if @tournament_num.nil? || @tournament_num.tournament_group_num.nil?
			@num = 1
		else
			@num = @tournament_num.tournament_group_num
			@num += 1
		end

		@group = Group.new(
			:tournament_group_num => @num,
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

  # countinue to payment
	def continue
		#hardcoded for now
	amount= 10.00
	redirect_to controller: 'charges', action: 'new', signup_params:form_params, amount: amount
	end

	def create


form_params= params[:form_params]
	    @amount = form_params[:amount]

	    @tournament_id = Tournament.where("tournaments.name LIKE ?", form_params[:tournament_name])

	    @tournament = Tournament.find_by id: @tournament_id.first.id

	    @transaction_num = [current_user.id, @tournament_id.first.id, Time.now.to_i]

			TicketTransaction.transaction do
			transaction=	TicketTransaction.new(
					:transaction_number=>@transaction_num.join.to_i,
			:user_id => current_user.id,

					#zero until payment processing is added
					:amount_paid=> 0
			)
			transaction.save
			transaction_id= transaction.id
	    if form_params[:player_tickets] == ''
			form_params[:player_tickets] = 0.to_s
		end

		if form_params[:foursome_tickets] == ''
			form_params[:foursome_tickets] = 0.to_s
		end

		@offset = 1
		@player_offset = 0
    @k = 0
		@s = 0
		@sponsor_offset = 0

			if form_params[:sponsor_level].to_i > 0
			@ticket_num = [@transaction_num, @offset]
			@tournament.people.new(
				:user_id => current_user.id,
				:is_sponsor => true,
				:ticket_transaction_id => transaction_id,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => form_params[:sponsor_level]
				).save
			@offset += 1
			@sponsor_offset = 1
		end

		if form_params[:foursome_tickets].to_i > 0
      if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_player = true", current_user.id, @tournament_id.first.id)).exists?
        @ticket_num = [@transaction_num, @offset]

        @tournament.people.new(
          :user_id => current_user.id,
          :is_player => true,
          :ticket_transaction_id => transaction_id,
          :ticket_number => @ticket_num.join.to_i,
          :ticket_description => 0
          ).save

        @l = @offset + 1
        @amount += 400

        while @l < @offset + 4
          @ticket_num = [@transaction_num, @l]
          @tournament.people.new(
          :guest_of => current_user.id,
          :is_guest => true,
          :ticket_transaction_id => transaction_id,
          :ticket_number => @ticket_num.join.to_i,
          :ticket_description => 0
          ).save

          @l += 1
        end
        assignfoursome

        @offset += 4

        @k = 1
      end
    elsif form_params[:player_tickets].to_i > 0
      if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_player = true", current_user.id, @tournament_id.first.id)).exists?
        @ticket_num = [@transaction_num, @offset]
        @tournament.people.new(
          :user_id => current_user.id,
          :is_player => true,
          :ticket_transaction_id=> transaction_id,
          :ticket_number => @ticket_num.join.to_i,
          :ticket_description => 0
          ).save
        assigngroup
        @player_offset = 1
        @offset += 1
        @amount += 100
      end
		elsif form_params[:spectator_tickets].to_i > 0
			if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_spectator = true", current_user.id, @tournament_id.first.id)).exists?
				@ticket_num = [@transaction_num, @offset]
				@tournament.people.new(
						:user_id => current_user.id,
						:is_spectator => true,
						:ticket_transaction_id=> transaction_id,
						:ticket_number => @ticket_num.join.to_i,
						:ticket_description => 4
				).save
				@offset += 1
				@s = 1
			end
		end

		while @k < form_params[:foursome_tickets].to_i
			@l = @offset
			while @l < @offset + 4
				@ticket_num = [@transaction_num, @l]
				@tournament.people.new(
				:guest_of => current_user.id,
				:is_guest => true,
				:ticket_transaction_id => transaction_id,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).save

				@l += 1
			end
			assignfoursome
			@k += 1
			@offset += 4
			
		end

		@i = @offset

		while @i < form_params[:player_tickets].to_i + @offset - @player_offset
			@ticket_num = [@transaction_num, @i]
			@tournament.people.new(
				:guest_of => current_user.id,
				:is_guest => true,
				:ticket_transaction_id => transaction_id,
				:ticket_number => @ticket_num.join.to_i,
				:ticket_description => 0
				).save
			assigngroup
			@i += 1
			
		end

			@tickets_left = @tournament.tickets_left - (@i - 1 + @s) + @sponsor_offset

			while @s < form_params[:spectator_tickets].to_i
				@ticket_num = [@transaction_num, @offset]
				@tournament.people.new(
						:guest_of => current_user.id,
						:is_spectator => true,
						:ticket_transaction_id=> transaction_id,
						:ticket_number => @ticket_num.join.to_i,
						:ticket_description => 4
				).save
				@offset += 1

				@s += 1
			end

			if @tournament.spectator_tickets_left.nil?
				@spectator_tickets_left = @tournament.total_audience_tickets - @s
			else
				@spectator_tickets_left = @tournament.spectator_tickets_left - @s
			end
			@tournament.update_column(:tickets_left, @tickets_left)
			@tournament.update_column(:spectator_tickets_left, @spectator_tickets_left)
			redirect_to controller: 'charges', action: 'new', transaction_id: transaction_id, amount: @amount

		end


			end

	def form_params
		params.permit(
			:spectator_tickets,
			:foursome_tickets,
			:tournament_name,
			:player_tickets,
			:sponsor_level
			)
	end
end
