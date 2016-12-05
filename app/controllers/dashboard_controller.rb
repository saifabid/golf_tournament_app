class DashboardController < ApplicationController
  before_action :check_user_auth
  def index
    @participatingtournaments= getpartipatingtournaments
    @createdtournaments= getcreatedtournaments
    @spectatortournaments= getspectatortournments
    @sponsoredtournaments= getsponsoredtournaments
  end
  def my_orders
    @orders= TicketTransaction.where(:user_id=>current_user.id).order("created_at DESC")
  end
  # returns json feed of participating tournaments
  def participatingtournaments_feed
    tournaments= getpartipatingtournaments
    tournamentslist = tournaments.map do |t|
      { :tournament_id=>t.id, :title=> t.name, :start => t.start_date }
    end

    render :json=> tournamentslist.to_json
  end
  def createdtournaments_feed
    tournaments= getcreatedtournaments
    tournamentslist = tournaments.map do |t|
      { :tournament_id=>t.id,:title=> t.name, :start => t.start_date }
    end

    render :json=> tournamentslist.to_json
  end
  def spectatortournaments_feed
    tournaments= getspectatortournments
    tournamentslist= tournaments.map do|t|
      {:tournament_id=>t.id,:title=> t.name, :start=> t.start_date}
    end
    render :json=> tournamentslist.to_json
  end
  def sponsoredtournaments_feed
    tournaments= getsponsoredtournaments
    tournamentslist= tournaments.map do|t|
      {:tournament_id=>t.id, :title=> t.name, :start=> t.start_date}
    end
    render :json=> tournamentslist.to_json
  end

  def get_tournament_modal
    tournament_id=params[:tournament_id]
    if(tournament_id.nil?)
      raise "no tournament id specified"
    end
    tournament= Tournament.find(tournament_id)
    if(tournament.nil?)
      raise "tournament #{tournament_id} not found"
    end
    render partial: 'tournaments/tournament_modal',locals:{:tournament=> tournament}

  end

  private
  def getpartipatingtournaments
    userid= current_user.id
    return Tournament.select('tournaments.*, people.created_at').joins(:people).where(:people => {:user_id=> userid, :is_player=>1, :is_guest=>nil} ).distinct(:id).order("people.created_at DESC")

  end
  def getcreatedtournaments
    userid= current_user.id
    return Tournament.select('tournaments.*, people.created_at').joins(:people).where(:people=> {:user_id=> userid, :is_organizer=> 1}).distinct(:id).order("people.created_at DESC")
  end

  def getspectatortournments
    userid= current_user.id
    return Tournament.select('tournaments.*, people.created_at').joins(:people).where(:people=> {:user_id=>userid, :is_spectator=> 1, :is_guest=> nil}).distinct(:id).order("people.created_at DESC")
  end
  def getsponsoredtournaments
    userid= current_user.id
    return Tournament.select('tournaments.*, people.created_at').joins(:people).where(:people=> {:user_id=> userid, :is_sponsor=> 1}).distinct(:id).order("people.created_at DESC")
  end


end
