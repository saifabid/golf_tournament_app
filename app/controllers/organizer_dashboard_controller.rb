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
  end
end
