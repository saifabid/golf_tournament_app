class TournamentsController < ApplicationController
  before_action only: [:new, :update, :destroy, :edit, :create] do
    check_user_auth('Please login before creating a new tournament')
  end
  before_action :check_tournament_organizer, only: [:show]

  before_action :check_private_event, only: [:show, :check_in, :check_in_fail, :guest_login, :guest_login_fail, :schedule]

  def index
    redirect_to "/"
  end

  def check_private_event
    session[:private_event_logged_in] ||= []
    if Tournament.where(id: params[:id]).where(:is_private => 1).exists? and !session[:private_event_logged_in].include? params[:id]
      redirect_to controller: 'tournaments',
        action: 'private_event_login',
        id: params[:id]
      return
    end
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
    uploaded_profile_picture = Image.store(:profile_picture, params[:images])
    if uploaded_profile_picture.nil?
      uploaded_profile_picture = []
    end

    params = tournament_params
    uploaded_logo = Image.store(:logo, params[:logo])
    if uploaded_logo.nil?
      uploaded_logo = {}
    end

    uploaded_venue_logo = Image.store(:venue_logo, params[:venue_logo])
    if uploaded_venue_logo.nil?
      uploaded_venue_logo = {}
    end

    params[:logo] = uploaded_logo["url"]
    params[:venue_logo] = uploaded_logo["url"]
    params[:profile_pictures] = uploaded_profile_picture

    if uploaded_profile_picture.length > 0
      profile_pic_arr = []
      @profile_pic_public_ids = []
      uploaded_profile_picture.each do |prof_pic|
        profile_pic_arr.push(prof_pic['url'])
        @profile_pic_public_ids.push(prof_pic['public_id'])
      end
      params[:profile_pictures] = profile_pic_arr
    end

    if params[:is_private] == "1"
      params[:private_event_password] = Tournament.create_private_event_hash
    end

    @tournament = Tournament.new(params)
    @tournament.tickets_left = params[:total_player_tickets].to_i

    @tournament.save
    if @tournament.errors.any?
      Image.delete_by_ids [uploaded_logo["public_id"],uploaded_venue_logo["public_id"]]
      Image.delete_by_ids @profile_pic_public_ids
      render :new
      return
    end

    if !@tournament.people.create({user_id: current_user.id, is_organizer: true})
      Image.delete_by_ids [uploaded_logo["public_id"],uploaded_venue_logo["public_id"]]
      Image.delete_by_ids @profile_pic_public_ids
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

    #retrieve sponsor logos
    #1. Get all users that are sponsors for this tournament
    #2. Get the profile_pics of those users

    #1.
    @sponsors_for_tournament = Person.where(tournament_id: params[:id]).where(:is_sponsor => 1);
    @sponsor_accounts = Account.find(@sponsors_for_tournament.map(&:user_id).uniq)


    # Countdown Timer
    # ToDo: when timer finishes, flash numbers indicating live
    @date = @tournament.start_date.strftime("%Y-%m-%d-%I:%M%P")
    gon.year = @date.split('-')[0]
    gon.month = @date.split('-')[1]
    gon.day = @date.split('-')[2]

    # Retrieve tickets left
    @tickets_left = @tournament.tickets_left

    # set session for other pages to link back to event page
    session[:tournament_id] = params[:id]

    # Check if user signed in or not
    @email = nil
    @profile_pic = nil
    @first_name = 'none'

    @no_group_need_to_buy_tickets = false
    @show_signup_button = true
    @buy_additional_tickets = false
    @people_for_tournament = Person.where(tournament_id: params[:id])
    if user_signed_in?
      # check if user is part of event
      @part_of_event = @people_for_tournament
        .where(user_id: current_user.id).exists?

      # if user is part of event,
      # check if part of group, if not, buy tickets
      if @part_of_event
        @show_signup_button = false
        # Get User credentials
        @account = Account.where(user_id: current_user.id).first()
        @first_name = @account.first_name rescue 'none'
        @last_name = @account.last_name rescue 'none'
        @profile_pic = @account.profile_pic rescue nil
        @user = User.where(id: current_user.id).first()
        @email = @user.email

        @user_tournament = @people_for_tournament
          .where(user_id: current_user.id)
        @is_signed_up = @user_tournament.where(is_player: 1).exists?

        # If already part of group, show group
        if @is_signed_up
          @buy_additional_tickets = true
        else
          # not part of any golf group
          @no_group_need_to_buy_tickets = true
        end
      else
        # not part of event, must sign up for event
        @no_group_need_to_buy_tickets = true
      end
    else
      #User is not logged in

      # Logged in as a guest
      if params[:is_valid_guest]
        @show_signup_button = false
        @is_valid_guest = params[:is_valid_guest] 
      end
    end

    if @is_signed_up or @is_valid_guest
      
      if @is_signed_up
        # Sign in user
        @curr_user = current_user.id

        @checked_in = Person.where(tournament_id: params[:id])
          .where(user_id: current_user.id)
          .where(checked_in: 1)
          .exists?
      elsif session[:guest_ticket_number] and session[:purchaser_email]
        # Guest user
        @purchaser_id = User.where(email: session[:purchaser_email]).first().id
        @checked_in = Person.where(guest_of: @purchaser_id)
          .where(ticket_number: session[:guest_ticket_number])
          .where(checked_in: 1)
          .exists?
      end

      # Generate checked_in table
      @people_for_tournament = Person.where(tournament_id: params[:id])
        .where("is_guest = 1 OR is_player = 1")
        .order("group_number asc")
      @account = Account.all
      @members = Array.new
      @people_for_tournament.each do |member|
        @people_data = {}
        if member.user_id
          @account = Account.where(user_id: member.user_id).first()
          @f_name = @account.first_name rescue 'none'
          @l_name = @account.last_name rescue ''
          if @f_name == 'none' or @f_name == ''
            @f_name = User.where(id: member.user_id).first().email
            @l_name = ''
          end
          @people_data['name'] = @f_name + " " + @l_name
        else
          @account = Account.where(user_id: member.guest_of).first()
          @f_name = @account.first_name rescue 'none'
          @l_name = @account.last_name rescue ''
          if @f_name == 'none' or @f_name == ''
            @f_name = User.where(id: member.guest_of).first().email
            @l_name = ''
          end
          @people_data['name'] = "Guest of " + @f_name + " " + @l_name
        end
        @tournament_group_num = Group.where("id = %d", member.group_number).last
        @people_data['group'] = @tournament_group_num.tournament_group_num
        @people_data['checked_in'] = member.checked_in
	      @people_data['score'] = member.score
        @members.push(@people_data)
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

  def check_in
    if params[:guest] == 'true'
      @person = Person.where(guest_of: params[:purchaser_id])
          .where(ticket_number: params[:ticket_number])
          .first()
      if @person.update(checked_in: 1)
        redirect_to controller: 'tournaments',
          action: 'show',
          id: params[:id],
          is_valid_guest: true
      else
        redirect_to 'tournaments/' + params[:id] + '/check_in_fail'
      end
    else
      @person = Person.where(tournament_id: params[:id])
          .where(user_id: current_user.id)
          .first()
      if @person.update(checked_in: 1)
        redirect_to controller: 'tournaments',
          action: 'show',
          id: params[:id]
      else
        redirect_to 'tournaments/' + params[:id] + '/check_in_fail'
      end
    end
  end

  def check_in_fail
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

        session[:guest_ticket_number] = params[:ticket_number]
        session[:purchaser_email] = params[:purchaser_email]

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

  def private_event_login
    @id = params[:id]
    if params[:id] and params[:password]
      @id = params[:tournament_id]
      if Tournament.where(id: @id).where(:is_private => 1).where(private_event_password: params[:password]).exists?
        session[:private_event_logged_in].push(@id)
        redirect_to controller: 'tournaments',
          action: 'show',
          id: @id
      else
        redirect_to '/tournaments/' + @id + '/private_event_login_fail'
      end
    end
  end

  def private_event_login_fail
    @id = params[:id]
  end

  def schedule
    @id = params[:id]

    if params[:searchTitle].blank?
      searchTitle = "%%"
    else
      searchTitle = "%"+params[:searchTitle]+"%"
    end
    
    @has_agenda = TournamentEvent.where(tournament_id: params[:id]).exists?
    if @has_agenda
      @agenda = TournamentEvent.where(tournament_id: params[:id])
        .where("event_name LIKE ?", searchTitle).order(start_time: :asc)
      if params[:query]
        if params[:query] == 'z_a'
          @agenda = TournamentEvent.where(tournament_id: params[:id])
            .where("event_name LIKE ?", searchTitle).order(event_name: :desc)
        elsif params[:query] == 'a_z'
          @agenda = TournamentEvent.where(tournament_id: params[:id])
            .where("event_name LIKE ?", searchTitle).order(event_name: :asc)
        elsif params[:query] == 'time_asc'
          @agenda = TournamentEvent.where(tournament_id: params[:id])
            .where("event_name LIKE ?", searchTitle).order(start_time: :asc)
        elsif params[:query] == 'time_desc'
          @agenda = TournamentEvent.where(tournament_id: params[:id])
            .where("event_name LIKE ?", searchTitle).order(start_time: :desc)
        end
      end
      if params[:reset]
        @agenda = TournamentEvent.where(tournament_id: params[:id]).order(start_time: :asc)
      end
    else
      # ToDo: Fix this, how to use render instead?
      redirect_to '/tournaments/' + @id
    end
  end
end
