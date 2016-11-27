class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def check_user_auth(notice = nil)
    redirect_to "/users/sign_in", notice:notice unless user_signed_in?
  end
  # saves the location before loading each page so we can return to the
  # right page. If we're on a devise page, we don't want to store that as the
  # place to return to (for example, we don't want to return to the sign in page
  # after signing in), which is what the :unless prevents
  before_filter :store_current_location, :unless => :devise_controller?

  def get_tournament_players_list
    @all_tournament_players = []
    all_persons = Person.where("tournament_id = ? AND is_player = 1", params[:id])
    # For each person thats part of a tournament we need to get their user information
    # And if they are a guest, we need to get their parent's information
    all_guests = all_persons.select{|person| person.is_guest == true}
    all_parent_players = all_persons.select{|person| person.user_id != nil}
    all_parent_players.each do |parent_player|
      if parent_player.user_id.to_i != 0 then
        account = Account.where("user_id = ?", parent_player.user_id).first
        user = User.where("id = ?", parent_player.user_id).first
        ac = Hash["account" => account, "email" => user.email, "is_guest" => false, "guest_number" => 0, "player" => parent_player]
        @all_tournament_players.append(ac)
        all_guests.each do |guest_player|
          if guest_player.guest_of == parent_player.user_id then
            ac["is_guest"] = true
            ac["guest_number"] = ac["guest_number"] + 1
            ac["player"] = guest_player
            @all_tournament_players.append(ac)
          end
        end
      end
    end

    return @all_tournament_players
  end

  def check_tournament_organizer_or_admin
    if(current_user.nil?)
      redirect_to sprintf("/tournaments/%s", params[:id])
      return
    end

    if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND (is_organizer = 1 OR is_admin = 1)", current_user.id, params[:id])).exists?
      redirect_to sprintf("/tournaments/%s", params[:id])
      return
    end
  end

  private
  # override the devise helper to store the current location so we can
  # redirect to it after loggin in or out. This override makes signing in
  # and signing up work automatically.
  def store_current_location
    store_location_for(:user, request.url)
  end
end

