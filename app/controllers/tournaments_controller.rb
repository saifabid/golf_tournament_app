class TournamentsController < ApplicationController
  before_action only: [:new, :update, :destroy, :edit, :create] do
    check_user_auth('Please login before creating a new tournament')
  end
  before_action :check_tournament_organizer, only: [:show]


  def index
    redirect_to "/"
  end

  def check_tournament_organizer
    if user_signed_in? && Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:id])).exists?
      redirect_to sprintf("/organizer_dashboard/%s", params[:id])
      return
    end
  end

  def new
    @tournament = Tournament.new
  end

  def create
    params = tournament_params
    uploaded_logo = Image.store(:logo, params[:logo])
    if uploaded_logo.nil?
      uploaded_logo = {}
    end

    uploaded_venue_logo = Image.store(:venue_logo, params[:venue_logo])
    if uploaded_venue_logo.nil?
      uploaded_venue_logo = {}
    end

    uploaded_profile_picture = Image.store(:profile_picture, params[:profile_picture])
    if uploaded_profile_picture.nil?
      uploaded_profile_picture = {}
    end

    params[:logo] = uploaded_logo["url"]
    params[:venue_logo] = uploaded_logo["url"]
    params[:profile_pictures] = uploaded_profile_picture["url"]

    @tournament = Tournament.new(params)
    @tournament.tickets_left = params[:total_player_tickets].to_i

    @tournament.save
    if @tournament.errors.any?
      Image.delete_by_ids [uploaded_logo["public_id"],uploaded_venue_logo["public_id"],uploaded_profile_picture["public_id"]]
      render :new
      return
    end

    if !@tournament.people.create({user_id: current_user.id, is_organizer: true})
      Image.delete_by_ids [uploaded_logo["public_id"],uploaded_venue_logo["public_id"],uploaded_profile_picture["public_id"]]
      render :new
      return
    end

    # Redirects organizer to view to setup tournament agenda of the day
    redirect_to new_tournament_tournament_event_path(@tournament.id)
  end

  def show
    @id = params[:id]
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
      @account = Account.where(user_id: current_user.id).first()
      @first_name = @account.first_name
      @last_name = @account.last_name
      @is_signed_up = @user_tournament
        .where(is_player: 1).exists?

      if @is_signed_up
        @player_tournament = @user_tournament
          .where(is_player: 1)
        @group_members = Person.where(tournament_id: params[:id])
          .where(group_number: @player_tournament.first.group_number)

        @group_number = @player_tournament.first.group_number
        @members = Array.new
        @group_members.each do |member|
          if member.user_id
            @members.push (@first_name + @last_name)
          else
            @guest_name = 'Guest of ' + @first_name + ' ' + @last_name
            @members.push(@guest_name)
          end
        end
      end
    else
      @session_user = 'none'
      @is_organizer = false
      @first_name = 'none'
      if params[:is_valid_guest]
        @is_valid_guest = params[:is_valid_guest]
        @group_members = Person.where(tournament_id: params[:id])
          .where(group_number: params[:group_number])
        @group_number = params[:group_number]
        @members = Array.new
        @group_members.each do |member|
          if member.user_id
            @account = Account.where(user_id: member.user_id).first()
            @first_name = @account.first_name
            @last_name = @account.last_name
            @members.push (@first_name + @last_name)
          else
            @guest_name = 'Guest of ' + @first_name + ' ' + @last_name
            @members.push(@guest_name)
          end
        end
      end
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
      :total_player_tickets,
      :total_audience_tickets,
      :logo,
      :venue_logo,
      :profile_picture
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

  def guest_login
    @id = params[:id]
    if params[:purchaser_email] and params[:ticket_number]
      @id = params[:tournament_id]
      @is_valid_guest = Person.where(tournament_id: params[:tournament_id])
        .where(ticket_number: params[:ticket_number]).exists?
      if @is_valid_guest
        @guest = Person.where(tournament_id: params[:tournament_id])
        .where(ticket_number: params[:ticket_number])
        @group_number = @guest.first().group_number
        redirect_to controller: 'tournaments',
          action: 'show',
          id: params[:tournament_id],
          is_valid_guest: true,
          group_number: @group_number
      else
        redirect_to '/tournaments/' + @id + '/guest_login_fail'
      end
    end
  end

  def guest_login_fail
    @id = params[:id]
  end

  def schedule
    @id = params[:id]
    @has_agenda = TournamentEvent.where(tournament_id: params[:id])
      .exists?
    if @has_agenda
      @agenda = TournamentEvent.where(tournament_id: params[:id])
    end
  end

end
