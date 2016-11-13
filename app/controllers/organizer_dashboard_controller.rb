class OrganizerDashboardController < ApplicationController

  before_action :check_tournament_organizer, only: [:show]

  def check_tournament_organizer
    if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:id])).exists?
      redirect_to sprintf("/tournaments/%s", params[:id])
      return
    end
  end

  def show
    @tournament = Tournament.where("id = ?", params[:id]).first
    puts @tournament.tickets_left

    @is_private = false
    if Tournament.where(id: params[:id]).where(:is_private => 1).exists?
      @is_private = true
      @private_event_password = Tournament.where(id: params[:id]).where(:is_private => 1).first().private_event_password
    end
  end
end
