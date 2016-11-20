class DashboardController < ApplicationController
  before_action :check_user_auth
  def index
    @participatingtournaments= getpartipatingtournaments
    @createdtournaments= getcreatedtournaments
    @spectatortournaments= getspectatortournments
  end

  # returns json feed of participating tournaments
  def participatingtournaments_feed
    tournaments= getpartipatingtournaments
    tournamentslist = tournaments.map do |t|
      { :title=> t.name, :start => t.start_date }
    end

    render :json=> tournamentslist.to_json
  end
  def createdtournaments_feed
    tournaments= getcreatedtournaments
    tournamentslist = tournaments.map do |t|
      { :title=> t.name, :start => t.start_date }
    end

    render :json=> tournamentslist.to_json
  end
  def spectatortournaments_feed
    tournaments= getspectatortournments
    tournamentslist= tournaments.map do|t|
      {:title=> t.name, :start=> t.start_date}
    end
    render :json=> tournamentslist.to_json
  end

  private
  def getpartipatingtournaments
    userid= current_user.id
    return Tournament.joins(:people).where(:people => {:user_id=> userid, :is_player=>1, :is_guest=>nil} )

  end
  def getcreatedtournaments
    userid= current_user.id
    return Tournament.joins(:people).where(:people=> {:user_id=> userid, :is_organizer=> 1})
  end

  def getspectatortournments
    userid= current_user.id
    return Tournament.joins(:people).where(:people=> {:user_id=>userid, :is_spectator=> 1, :is_guest=> nil})
  end



end
