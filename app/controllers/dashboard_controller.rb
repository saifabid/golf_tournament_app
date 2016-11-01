class DashboardController < ApplicationController
  before_action :check_user_auth
  def index
    @participatingtournaments= getpartipatingtournaments
    @createdtournaments= getcreatedtournaments
  end
  def getpartipatingtournaments
    userid= current_user.id
    return Tournament.joins(:people).where(:people => {:user_id=> userid, :is_player=>1, :is_guest=>nil} )

  end
  def getcreatedtournaments
    userid= current_user.id
    return Tournament.joins(:people).where(:people=> {:user_id=> userid, :is_organizer=> 1})
  end
end
