class TournamentsController < ApplicationController
  before_action only: [:new, :update, :destroy, :edit, :create] do
    check_user_auth("Please login before creating a new tournament")
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

  def show
    @tournament = Tournament.find(params[:id])
    if @tournament.errors.any?
      render :new
      return 
    end 

    # 3 cases of users.
    # 1. Organizer
    # 2. Attendee 
    # 3. Not logged in. Can log in as organizer or attendee
    if user_signed_in?
      @session_user = current_user
      @is_organizer = Person.where(tournament_id: params[:id]).where(user_id: current_user.id).where(is_organizer: 1).exists?
      @first_name = 'Leroy Jenkins'
    else 
      @session_user = 'none'
      @is_organizer = false
      @first_name = 'none'
    end  
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
