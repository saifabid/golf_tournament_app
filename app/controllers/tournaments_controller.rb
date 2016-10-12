class TournamentsController < ApplicationController
  before_action :check_user_auth, only: [:new, :update, :destroy, :edit, :create]

  def check_user_auth
    redirect_to "/users/sign_in", notice: "Please login before creating a new tournament" unless user_signed_in?
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.create_tournament
    if (@tournament.errors.any?)
      render :new
      return
    end

    @tournament.person.new.insert_organizer current_user.id
    if (@tournament.errors.any?)
      render :new
      return
    end

    render :new # TODO: change this to success view
  end


  def tournament_params
    # fields we want to perform any operations on on in this controller
    params.require(:tournament).permit(
        :name,
        :language,
        :currency,
        :details,
        :venue_name,
        :venue_address,
        :venue_website,
        :venue_contact_details,
        :is_private,
        :start_date,
        :logo_data,
        :venue_logo_data,
        :profile_picture_data
    )
  end
end
