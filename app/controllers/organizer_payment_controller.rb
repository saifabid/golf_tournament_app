class OrganizerPaymentController < ApplicationController

  before_action :check_tournament_organizer_or_admin, only: [:show]
  #before_action :ensure_tournament_started, only: [:show]

  def ensure_tournament_started
    @tournament = Tournament.find(params[:id])

    if(Time.now.strftime("%d-%m-%Y %H:%M:%S") < @tournament.start_date)
      redirect_to sprintf("/tournaments/%s", params[:id])
      return
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
    @num = (@tournament.player_surcharge/2.50).to_i
    @surcharge = @tournament.player_surcharge*0.04
    @total = @tournament.player_surcharge + @surcharge
    @currency = @tournament.currency

    params[:tournament_id] = params[:id]

    price_line=PriceLine.new(@num, 2.50, @tournament.player_surcharge, 'Player Charges')
    price_lines=[]
    price_lines.push(price_line)

    @price_lines=price_lines

    @total_cents = @total*100

    currency=@tournament.currency==nil? ? 'cad' : @tournament.currency


  end

  def create

    @tournament = Tournament.find(params[:tournament_id])
    @num = (@tournament.player_surcharge/2.50).to_i
    @surcharge = @tournament.player_surcharge*0.04
    @total = @tournament.player_surcharge + @surcharge
    @currency = @tournament.currency

    @total_cents = @total*100

    begin
      charge = Stripe::Charge.create(
          :amount => @total_cents.floor,
          :description => "Golf Tournament Organizer Fees for :#{@tournament.name}",
          :source => params[:stripeToken],
          :currency => @currency,
      )


    rescue Stripe::CardError => e
      flash[:error] = e.message
      render :new
      return
    end

    redirect_to sprintf("/organizer_dashboard/%s", params[:tournament_id])
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