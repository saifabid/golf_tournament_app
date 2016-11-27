class OrganizerPaymentController < ApplicationController

  before_action :check_tournament_organizer_or_admin, only: [:show]

  def show

  end
end