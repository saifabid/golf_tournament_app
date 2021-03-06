class OrganizerDashboardController < ApplicationController

  before_action :check_tournament_organizer_or_admin, only: [:show]

  def show
    @tournament = Tournament.where("id = ?", params[:id]).first
    @all_tournament_players = get_tournament_players_list
    @current_player = Person.where("user_id = ? AND tournament_id = ?", current_user.id, params[:id]).first
    @is_private = false
    if Tournament.where(id: params[:id]).where(:is_private => 1).exists? then
      @is_private = true
      @private_event_password = Tournament.where(id: params[:id]).where(:is_private => 1).first().private_event_password
    end
  end

  def survey_setup
    @person = Person.where("user_id = ? AND tournament_id = ?", current_user.id, params[:id]).first
    redirect_to sprintf("/rapidfire/surveys/%d/questions", @person.survey_admin)
  end

  def survey_answers
    @person = Person.where("user_id = ? AND tournament_id = ?", current_user.id, params[:id]).first
     redirect_to sprintf("/rapidfire/surveys/%d/results", @person.survey_admin)
  end

  def set_golf_course_admin
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"is_golf_course_admin" => true})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def unset_golf_course_admin
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"is_golf_course_admin" => false})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def set_company_csr
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"company_csr" => true})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def unset_company_csr
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"company_csr" => false})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def set_golf_course_csr
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"golf_course_csr" => true})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def unset_golf_course_csr
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"golf_course_csr" => false})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def set_company_rep
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"company_rep" => true})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def unset_company_rep
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"company_rep" => false})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def check_player_in
    @player = Person.where("id = ?", params[:player_id])
    if !Person.where(sprintf("tournament_id = %s AND checked_in = true", @player.first.tournament_id)).exists?
      Resend.organizer_balance(@player.first.tournament_id)
    end

    @player.update({"checked_in" => true})
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def check_player_out
    @player = Person.where("id = ?", params[:player_id])
    @player.update({"checked_in" => false})
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

  def send_player_email_ticket
    @player = Person.where("id = ?", params[:player_id])
    @id = @player.first.id
    message_text = params[:body]
    # TODO: Call Seyans email save function with params: (params[:recipiant], params[:body])
    Resend.send_email_with_ticket params[:recipiant], message_text, @id
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def send_password
    Resend.send_password params[:recipiant], params[:id]
    redirect_to sprintf("/organizer_dashboard/%s", params[:id])
  end

  def view_public
    @organizer = Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:id])).first
    @organizer.update_column(:org_view_public, true)

    redirect_to sprintf("/tournaments/%s", @organizer.tournament_id)
  end

end
