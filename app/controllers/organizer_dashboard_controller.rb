class OrganizerDashboardController < ApplicationController

  before_action :check_tournament_organizer_or_admin, only: [:show]

  def check_tournament_organizer_or_admin
    if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND (is_organizer = 1 OR is_admin = 1)", current_user.id, params[:id])).exists?
      redirect_to sprintf("/tournaments/%s", params[:id])
      return
    end
  end

  def show
    @tournament = Tournament.where("id = ?", params[:id]).first
    @all_tournament_playars = get_tournament_players_list
    @current_player = Person.where("user_id = ? AND tournament_id = ?", current_user.id, params[:id]).first
    @is_private = false
    if Tournament.where(id: params[:id]).where(:is_private => 1).exists? then
      @is_private = true
      @private_event_password = Tournament.where(id: params[:id]).where(:is_private => 1).first().private_event_password
    end
  end

  def check_player_in
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"checked_in" => true})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def set_player_admin
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"is_admin" => true})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def remove_player_admin
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"is_admin" => false})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def send_player_email
    @player = Person.where("id = ?", params[:player_id])
    @id = @player.first.id
    message_text = params[:body]
    # TODO: Call Seyans email save function with params: (params[:recipiant], params[:body])
    Resend.send_email params[:recipiant], params[:body], @id
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def get_tournament_players_list
    @all_tournament_playars = []
    all_persons = Person.where("tournament_id = ? AND is_player = 1", params[:id])
    # For each person thats part of a tournament we need to get their user information
    # And if they are a guest, we need to get their parent's information
    all_guests = all_persons.select{|person| person.is_guest == true && person.guest_of > 0}
    all_parent_players = all_persons.select{|person| person.user_id > 0 && person.is_player == true}
    all_parent_players.each do |parent_player|
      if parent_player.user_id.to_i != 0 then
        account = Account.where("user_id = ?", parent_player.user_id)
        user = User.where("id = ?", parent_player.user_id).first
        ac = Hash["account" => account, "email" => user.email, "is_guest" => false, "guest_number" => 0, "player" => parent_player]
        @all_tournament_playars.append(ac)
        all_guests.each do |guest_player|
          if guest_player.guest_of == parent_user_id then
            ac["is_guest"] = true
            ac["guest_number"] = ac[guest_number] + 1
            ac["player"] = guest_player
            @all_tournament_playars.append(ac)
          end
        end
      end
    end

    return @all_tournament_playars
  end
end
