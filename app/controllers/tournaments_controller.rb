class TournamentsController < ApplicationController
  before_action only: [:new, :update, :destroy, :edit, :create] do
    check_user_auth('Please login before creating a new tournament')
  end

  def index
    redirect_to "/"
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.create_tournament
    if @tournament.errors.any?
      render :new
      return
    end

    @tournament.person.new.insert_organizer current_user.id
    if @tournament.errors.any?
      render :new
      return
    end

    # Redirects organizer to view to setup tournament agenda of the day
    redirect_to sprintf("/tournaments/%s/tournament_events", @tournament.id)
  end

  def show
    @tournament = Tournament.find(params[:id])
    if @tournament.errors.any?
      render :new
      return
    end

    # Map
    marker_info = @tournament.venue_name + ' @ ' + @tournament.venue_address.partition(',').first
    puts marker_info
    @hash = Gmaps4rails.build_markers(@tournament) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
      marker.infowindow marker_info
    end

    # Countdown Timer
    # ToDo: when timer finishes, flash numbers indicating live
    @date = @tournament.start_date.strftime("%Y-%m-%d-%I:%M%P")
    gon.year = @date.split('-')[0]
    gon.month = @date.split('-')[1]
    gon.day = @date.split('-')[2]

    # User cases
    # 1. Organizer
    # 2. Attendee
    # 3. Not logged in. Can log in as organizer or attendee
    if user_signed_in?
      @session_user = current_user
      @user_tournament = Person.where(tournament_id: params[:id])
        .where(user_id: current_user.id)

      @is_organizer = @user_tournament.where(is_organizer: 1).exists?
      # ToDo: Pull this data from Accounts table
      @first_name = 'Leroy Jenkins'
      @is_signed_up = @user_tournament
        .where(is_player: 1).exists?

      if @is_signed_up
        @player_tournament = @user_tournament
          .where(is_player: 1)
        @group_members = Person.where(tournament_id: params[:id])
          .where(group_number: @player_tournament.first.group_number)

        @members = Array.new
        @group_members.each do |member|
          if member.user_id
            # map user_id to Accounts table and retrieve first last name
            @members.push ('Leroy Jenkins')
          else
            @members.push('Guest of user #')
          end
        end
      end
    else
      @session_user = 'none'
      @is_organizer = false
      @first_name = 'none'
    end
  end

  def success
    redirect_to @tournament
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(tournament_params)
      redirect_to @tournament
    else
      Rails.logger.info(@tournament.errors.messages.inspect)
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
      :profile_picture_data,
      :total_player_tickets,
      :total_audience_tickets
    )
  end

  def edit
    return render :new unless Tournament.exists?(id: params[:id])
    if session["warden.user.user.key"]
      @session_user = User.find(session["warden.user.user.key"][0][0])
      @is_organizer = Person.where(tournament_id: params[:id])
        .where(user_id: @session_user.id)
        .where(is_organizer: 1)
        .exists?
      if !@is_organizer
        render :new
        return
      else
        @tournament = Tournament.find(params[:id])
        @id = params[:id]
      end
    else
      render :new
      return
    end
  end

end
