require "prawn"

class TournamentStatsController < ApplicationController
    before_action :check_tournament_organizer_or_admin, only: [:show]

  def show
    calculate

    dict = {}
    @counter = 0
    Person.where(tournament_id: params[:id]).find_each do |person|
      if person.ticket_number
        if dict[person.created_at.strftime("%Y-%m-%d")].nil?
          if kind_of(person) != "ignore"
            dict[person.created_at.strftime("%Y-%m-%d")] = Hash[kind_of(person) => 1]
          end
        else
          if dict[person.created_at.strftime("%Y-%m-%d")][kind_of(person)].nil?
            if kind_of(person) != "ignore"
              dict[person.created_at.strftime("%Y-%m-%d")].update(kind_of(person) => 1)
            end
          else
            dict[person.created_at.strftime("%Y-%m-%d")][kind_of(person)] += 1
          end
        end
      end
    end
    @all_data = []
    dict.each do |key, value|
      temp = [key]
      
      if value["players"].nil?
        temp.append(0)
      else
        temp.append(value["players"])
      end

      if value["spectators"].nil?
        temp.append(0)
      else
        temp.append(value["spectators"])
      end

      if value["dinners"].nil?
        temp.append(0)
      else
        temp.append(value["dinners"])
      end

      @all_data.append(temp)
    end
  end

  def kind_of(person)
    if person.is_player == true
      return "players"
    elsif person.is_spectator == true
      return "spectators"
    elsif person.is_dinner == true
      return "dinners"
    else
      return "ignore"
    end
  end

  def download_pdf
    send_data(generate_pdf, :filename => "output.pdf", :type => "application/pdf", disposition: "attachment")
  end

  def generate_pdf
    d = generate_event_data_string()
    Prawn::Document.new do
      text d
    end.render

  end

  def generate_event_data_string
    msg = ""
    calculate

    "\tEvent Stats Data Export:\n\nTournament Name: #{@tournament_name}\n\n
     Player Tickets Left: #{@tournament.tickets_left}\n\n
     Player Tickets Sold: #{@player_tickets_sold}\n\n
     Spectator Tickets Left: #{@spectator_tickets_left}\n\n
     Spectator Tickets Sold: #{@spectator_tickets_sold}\n\n
     Dinner Tickets Left: #{@dinner_tickets_left}\n\n
     Dinner Tickets Sold: #{@dinner_tickets_sold}\n\n
     Revenue: #{@revenue}\n\n
     Net Profit: #{@net}"
  end

  def calculate
    @id = params[:id]
    @tournament = Tournament.find(params[:id])
    @tournament_name = @tournament.name

    @num_checked_in = 0
    Person.where(tournament_id: @id, checked_in: true).find_each do |person|
      @num_checked_in += 1
    end

    @num_sponsors = 0
    @revenue_sponsors = 0
    TournamentSponsorship.where(tournament_id: @id).find_each do |sponsor|
      @num_sponsors += 1
      case sponsor.sponsor_type
        when 1
          @revenue_sponsors += Tournament.find(@id).gold_sponsor_price
        when 2
          @revenue_sponsors += Tournament.find(@id).silver_sponsor_price
        when 3
          @revenue_sponsors += Tournament.find(@id).bronze_sponsor_price
        end
    end

    @player_tickets_left = @tournament.tickets_left
    @player_tickets_sold = @tournament.total_player_tickets - @player_tickets_left
    @spectator_tickets_left = @tournament.spectator_tickets_left
    @spectator_tickets_sold = @tournament.total_audience_tickets - @spectator_tickets_left
    @dinner_tickets_left = @tournament.dinner_tickets_left
    @dinner_tickets_sold = @tournament.total_dinner_tickets - @dinner_tickets_left
    begin
      @revenue_players = (@player_tickets_sold - 4 * @tournament.num_foursomes) * @tournament.player_price
      @revenue_foursomes = @tournament.num_foursomes * @tournament.foursome_price
    rescue
      @revenue_foursomes = 0
      @revenue_players = @player_tickets_sold * @tournament.player_price
    end
    @revenue_spectators = @spectator_tickets_sold * @tournament.spectator_price
    @revenue_dinner = @dinner_tickets_sold * @tournament.dinner_price
    
    @revenue = @revenue_players + @revenue_foursomes + @revenue_spectators + @revenue_dinner + @revenue_sponsors

    @potential_revenue_players = @player_tickets_left * @tournament.player_price
    @potential_revenue_spectators = @spectator_tickets_left * @tournament.spectator_price
    @potential_revenue_dinner = @dinner_tickets_left * @tournament.dinner_price
    @potential_revenue = @potential_revenue_players + @potential_revenue_spectators + @potential_revenue_dinner

    @cost = (@tournament.total_player_tickets - @player_tickets_left) * 2.5

    @net = @revenue - @cost

    @num_guests = 0
    Person.where(tournament_id: @id, is_guest: true).find_each do |person|
      @num_guests += 1
    end
  end

 end
