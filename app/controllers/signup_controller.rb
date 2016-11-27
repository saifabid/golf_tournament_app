require 'pdfkit'
require 'tempfile'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

# TODO: Change name, signup is confusing
class SignupController < ApplicationController
  helper_method :assigngroup, :assignfoursome
  before_action :check_user_auth, except: [:new]
  before_action :check_number_tickets, only: [:before_payment_summary]
  before_action :check_positive_amounts, only: [:before_payment_summary]



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
    send_data pdf, type: 'application/pdf', disposition: 'attachment', filename: 'ticket.pdf'
  end

  def signup_summary
    transaction_id= params[:transaction_id]
    transaction= TicketTransaction.find(transaction_id)
    if (transaction.user_id!= current_user.id)
      raise 'You are not permitted to view this transaction'
    end
    @transaction_num = transaction.transaction_number
    people= Person.where(:ticket_transaction_id => transaction_id)
    @tickets= people.where('is_guest= 1 OR is_player = 1 OR is_spectator=1 OR is_sponsor=1 OR is_dinner=1')

  end


  def new
    flash[:error] = ""
    @tournament = Tournament.where("start_date > NOW() AND is_private != 1")
                      .where("tickets_left > 0 OR dinner_tickets_left > 0 OR spectator_tickets_left > 0").all
  end

  def signup_from_tournament
    @tournament = Tournament.find(params[:id])

  end

  def index
    redirect_to "/signup/new"
  end

  def check_number_tickets

    @total_tickets = params[:player_tickets].to_i + 4*params[:foursome_tickets].to_i

    @tournament_id = params[:tournament_id]

    @tournament = Tournament.find(@tournament_id)

    if @total_tickets > @tournament.tickets_left.to_i
      flash[:error] = "You have selected more tickets than what's available"
      redirect_to(sprintf("/signup/%s", @tournament_id))
      return
    else
      flash[:error] = ""
    end

    @total_spectator_tickets = params[:spectator_tickets].to_i

    if @total_spectator_tickets > @tournament.tickets_left.to_i * 4
      flash[:error] = "You have selected more tickets than what's available"
      redirect_to(sprintf("/signup/%s", @tournament_id))
      return
    else
      flash[:error] = ""
    end

    @total_foursome_tickets = params[:foursome_tickets].to_i

    if @total_spectator_tickets > @tournament.spectator_tickets_left.to_i
      flash[:error] = "You have selected more tickets than what's available"
      redirect_to(sprintf("/signup/%s", @tournament_id))
      return
    else
      flash[:error] = ""
    end

    @total_dinner_tickets = params[:dinner_tickets].to_i

    if @total_dinner_tickets > @tournament.dinner_tickets_left.to_i
      flash[:error] = "You have selected more tickets than what's available"
      redirect_to(sprintf("/signup/%s", @tournament_id))
      return
    else
      flash[:error] = ""
    end
  end

  def check_positive_amounts

    @tournament_id = params[:tournament_id]

    if params[:player_tickets] != "" && params[:player_tickets].to_i < 0
      flash[:error] = "Negative"
      redirect_to(sprintf("/signup/%s", @tournament_id))
    end

    if params[:foursome_tickets] != "" && params[:foursome_tickets].to_i < 0
      flash[:error] = "Negative"
      redirect_to(sprintf("/signup/%s", @tournament_id))
    end

    if params[:spectator_tickets] != "" && params[:spectator_tickets].to_i < 0
      flash[:error] = "Negative"
      redirect_to(sprintf("/signup/%s", @tournament_id))
    end

    if params[:dinner_tickets] != "" && params[:dinner_tickets].to_i < 0
      flash[:error] = "Negative"
      redirect_to(sprintf("/signup/%s", @tournament_id))
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

  # gets an array for the
  def get_price_summary(tournament, num_player, sponsor_level, num_spectator, num_foursome, num_dinner)
    price_lines=[]

    total=0
    #get player total
    if (num_player>0)
      player_price= tournament.player_price
      subtotal= player_price* num_player

      player_price_line=PriceLine.new(num_player, player_price, subtotal, 'Player Tickets(s)')
      price_lines.push(player_price_line)

      total+= subtotal
    end
    if (num_spectator>0)
      spectator_price= tournament.spectator_price
      subtotal=spectator_price* num_spectator

      spectator_price_line=PriceLine.new(num_spectator, spectator_price, subtotal, 'Spectator Ticket(s)')
      price_lines.push(spectator_price_line)
      total+= subtotal
    end
    if (num_foursome>0)
      foursome_price= tournament.foursome_price
      subtotal= foursome_price* num_foursome

      foursome_price_line=PriceLine.new(num_foursome, foursome_price, subtotal, 'Foursome Ticket(s)')
      price_lines.push(foursome_price_line)
      total+= subtotal
    end
    if (num_dinner>0)
      dinner_price = tournament.dinner_price
      subtotal= dinner_price* num_dinner

      dinner_price_line=PriceLine.new(num_dinner, dinner_price, subtotal, 'Dinner Ticket(s)')
      price_lines.push(dinner_price_line)
      total+= subtotal
    end
    #get sponsor total
    sponsor_info= get_sponsor_info(tournament, sponsor_level)
    sponsor_text= sponsor_info[:text]
    sponsor_price= sponsor_info[:price]
    if (sponsor_price>0)
      sponsor_price_line= PriceLine.new(1, sponsor_price, sponsor_price, "Sponsor Ticket(s) (#{sponsor_text})")
      price_lines.push(sponsor_price_line)
      total+= sponsor_price
    end
    return {:total => total, :price_lines => price_lines}
  end

  def get_sponsor_info(tournament, sponsor_level)
    case sponsor_level
      when '1' #gold
        price= tournament.gold_sponsor_price
        text= 'Gold'
      when '2' #silver
        price= tournament.silver_sponsor_price
        text= 'Silver'
      when '3' #bronze
        price= tournament.bronze_sponsor_price
        text= 'Bronze'
      else
        price= 0
        text= 'Invalid Sponsor level'

    end
    return {:price=> price, :text=> text}

  end


  def before_payment_summary
    @tournament_id= form_params[:tournament_id]
    
    tournament= Tournament.find(@tournament_id)
    # TODO: if not found raise error
    @currency= tournament.currency==nil? ? 'cad': tournament.currency

    @player_tickets=form_params[:player_tickets]== '' ? 0 : form_params[:player_tickets].to_i
    @foursome_tickets= form_params[:foursome_tickets]== '' ? 0 : form_params[:foursome_tickets].to_i
    @spectator_tickets= form_params[:spectator_tickets]=='' ? 0 : form_params[:spectator_tickets].to_i
    @dinner_tickets= form_params[:dinner_tickets]=='' ? 0 : form_params[:dinner_tickets].to_i
    @sponsor_level= form_params[:sponsor_level].to_s

    price_summary= get_price_summary(tournament, @player_tickets, @sponsor_level, @spectator_tickets, @foursome_tickets, @dinner_tickets)
    @total= price_summary[:total]
    @price_lines=price_summary[:price_lines]
    @surcharge = @total * 0.04
    @total += @surcharge

  end

  def create

    #recalculate pricing for security purposes, to prevent forgery

    @amount = 0
    @tournament_id = form_params[:tournament_id]

    tournament= Tournament.find(@tournament_id)
    @tournament = tournament
    # TODO: if not found raise error


    @transaction_num = [current_user.id, @tournament_id, Time.now.to_i]

    @player_tickets=form_params[:player_tickets]== '' ? 0 : form_params[:player_tickets].to_i
    @foursome_tickets= form_params[:foursome_tickets]== '' ? 0 : form_params[:foursome_tickets].to_i
    @spectator_tickets= form_params[:spectator_tickets]=='' ? 0 : form_params[:spectator_tickets].to_i
    @dinner_tickets= form_params[:dinner_tickets]=='' ? 0 : form_params[:dinner_tickets].to_i
    @sponsor_level= form_params[:sponsor_level].to_s

    price_summary= get_price_summary(tournament, @player_tickets, @sponsor_level, @spectator_tickets, @foursome_tickets, @dinner_tickets)

    @total= price_summary[:total]
    @price_lines=price_summary[:price_lines]
    @surcharge = @total*0.04

    @total_cents = @total * 100
    currency=tournament.currency==nil? ? 'cad' : tournament.currency
    @surcharge_cents = @total_cents * 0.04
    @total_cents += @surcharge_cents

    #process payments using stripe
    begin
      charge = Stripe::Charge.create(
          :amount => @total_cents.floor,
          :description => "Golf Tournament Signup Transaction Num:#{@transaction_num.join.to_i}",
          :source => params[:stripeToken],
          :currency => currency,
      )


    rescue Stripe::CardError => e
      flash[:error] = e.message
      render :new
      return
    end

    TicketTransaction.transaction do
      transaction= TicketTransaction.new(
          :transaction_number => @transaction_num.join.to_i,
          :user_id => current_user.id,
          :currency=> currency,
          :amount_paid => @total,
          :card_surcharge => @surcharge
      )
      transaction.save
      transaction_id= transaction.id

      if form_params[:player_tickets] == ''
        form_params[:player_tickets] = 0.to_s
      end

      if form_params[:foursome_tickets] == ''
        form_params[:foursome_tickets] = 0.to_s
      end

      if form_params[:spectator_tickets] == ''
        form_params[:spectator_tickets] = 0.to_s
      end

      if form_params[:dinner_tickets] == ''
        form_params[:dinner_tickets] = 0.to_s
      end

      @offset = 1
      @player_offset = 0
      @k = 0
      @s = 0
      @d = 0
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
        if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_player = true", current_user.id, @tournament_id)).exists?
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
                :is_player => true,
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
        if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_player = true", current_user.id, @tournament_id)).exists?
          @ticket_num = [@transaction_num, @offset]
          @tournament.people.new(
              :user_id => current_user.id,
              :is_player => true,
              :ticket_transaction_id => transaction_id,
              :ticket_number => @ticket_num.join.to_i,
              :ticket_description => 0
          ).save
          assigngroup
          @player_offset = 1
          @offset += 1
          @amount += 100
        end
      elsif form_params[:spectator_tickets].to_i > 0
        if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_spectator = true", current_user.id, @tournament_id)).exists?
          @ticket_num = [@transaction_num, @offset]
          @tournament.people.new(
              :user_id => current_user.id,
              :is_spectator => true,
              :ticket_transaction_id => transaction_id,
              :ticket_number => @ticket_num.join.to_i,
              :ticket_description => 4
          ).save
          @offset += 1
          @s = 1
        end
      elsif form_params[:dinner_tickets].to_i > 0
      if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_dinner = true", current_user.id, @tournament_id)).exists?
        @ticket_num = [@transaction_num, @offset]
        @tournament.people.new(
            :user_id => current_user.id,
            :is_dinner => true,
            :ticket_transaction_id => transaction_id,
            :ticket_number => @ticket_num.join.to_i,
            :ticket_description => 4
        ).save
        @offset += 1
        @d = 1
      end
      end

      while @k < form_params[:foursome_tickets].to_i
        @l = @offset
        while @l < @offset + 4
          @ticket_num = [@transaction_num, @l]
          @tournament.people.new(
              :guest_of => current_user.id,
              :is_player => true,
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
            :is_player => true,
            :is_guest => true,
            :ticket_transaction_id => transaction_id,
            :ticket_number => @ticket_num.join.to_i,
            :ticket_description => 0
        ).save
        assigngroup
        @i += 1

      end

      @tickets_left = @tournament.tickets_left - (params[:player_tickets].to_i + params[:foursome_tickets].to_i * 4)

      while @s < form_params[:spectator_tickets].to_i
        @ticket_num = [@transaction_num, @offset]
        @tournament.people.new(
            :guest_of => current_user.id,
            :is_spectator => true,
            :is_guest => true,
            :ticket_transaction_id => transaction_id,
            :ticket_number => @ticket_num.join.to_i,
            :ticket_description => 4
        ).save
        @offset += 1

        @s += 1
      end



      while @d < form_params[:dinner_tickets].to_i
        @ticket_num = [@transaction_num, @offset]
        @tournament.people.new(
            :guest_of => current_user.id,
            :is_dinner => true,
            :is_guest => true,
            :ticket_transaction_id => transaction_id,
            :ticket_number => @ticket_num.join.to_i,
            :ticket_description => 4
        ).save
        @offset += 1

        @d += 1
      end

      if @tournament.spectator_tickets_left.nil?
        @spectator_tickets_left = @tournament.total_audience_tickets - @s
      else
        @spectator_tickets_left = @tournament.spectator_tickets_left - @s
      end

      if @tournament.dinner_tickets_left.nil?
        @dinner_tickets_left = @tournament.total_dinner_tickets - @d
      else
        @dinner_tickets_left = @tournament.dinner_tickets_left - @d
      end

      if @tournament.num_foursomes.nil?
        @foursome_tickets_sold = @k
      else
        @foursome_tickets_sold = @tournament.num_foursomes + @k
      end

      if @tournament.card_surcharge.nil?
        @transaction_surcharge = @surcharge
      else
        @transaction_surcharge = @tournament.card_surcharge + @surcharge
      end

      if @tournament.player_surcharge.nil?
        @player_surcharge = ((params[:player_tickets].to_i + params[:foursome_tickets].to_i * 4) * 2.50)
      else
        @player_surcharge = @tournament.player_surcharge + ((params[:player_tickets].to_i + params[:foursome_tickets].to_i * 4) * 2.50)
      end

      @tournament.update_column(:tickets_left, @tickets_left)
      @tournament.update_column(:spectator_tickets_left, @spectator_tickets_left)
      @tournament.update_column(:dinner_tickets_left, @dinner_tickets_left)
      @tournament.update_column(:num_foursomes, @foursome_tickets_sold)
      @tournament.update_column(:card_surcharge, @transaction_surcharge)
      @tournament.update_column(:player_surcharge, @player_surcharge)

      redirect_to controller: 'signup', action: 'signup_summary', transaction_id: transaction_id

    end


  end

  def form_params
    params.permit(
        :spectator_tickets,
        :dinner_tickets,
        :foursome_tickets,
        :tournament_id,
        :player_tickets,
        :sponsor_level
    )
  end
end

class PriceLine
  def initialize (quantity, unit_price, sub_total, name)
    @quantity = quantity
    @unit_price = unit_price
    @sub_total = sub_total
    @name= name

  end

  def quantity
    @quantity
  end

  def unit_price
    @unit_price
  end

  def sub_total
    @sub_total
  end



  def name
    @name
  end
end

