class TournamentsController < ApplicationController
    def new
      # If user isnt logged in dont let him enter the form
    end

    def create
      # Confirm user is logged in
      return self.error() unless session["warden.user.user.key"]
      @user = User.find(session["warden.user.user.key"][0][0])
      return self.error() unless @user

      # Store images. If no images provided, it isn't an error. Continue storing data
      logo_url = Image.store(:logo, image_store_params[:logo])
      venue_logo_url = Image.store(:venue_logo, image_store_params[:venue_logo])
      profile_picture_url = Image.store(:tournament_profile_picture, image_store_params[:profile_picture])
      @tournament = Tournament.new({:name => tournament_params[:name],
                                    :language => tournament_params[:language],
                                    :currency => tournament_params[:currency],
                                    :details => tournament_params[:details],
                                    :venue_name => tournament_params[:venue_name],
                                    :venue_address => tournament_params[:venue_address],
                                    :venue_website => tournament_params[:venue_website],
                                    :venue_contact_details => tournament_params[:venue_contact],
                                    :is_private => tournament_params[:private_event],
                                    :logo => logo_url,
                                    :profile_pictures => [profile_picture_url],
                                    :venue_logo => venue_logo_url,
                                    :start_date => tournament_params[:start_date]
                                   })

      return self.error() unless @tournament.register
      return self.error() unless @tournament.person.new().insert_organizer @user.id
      return self.success()
    end

    def image_store_params
      params.permit(:logo, :venue_logo, :profile_picture)
    end

    # Placeholder to be replaced by success view
    def success
      render :new
    end

    # Placeholder to be replaced by failiure view
    def error
      render :new
    end
    def tournament_params
      # fields we want to perform any operations on on in this controller
      params.permit(
          :name,
          :language,
          :currency,
          :details,
          :venue_name,
          :venue_address,
          :venue_website,
          :venue_contact,
          :private_event,
          :start_date
      )
    end
end
