class TournamentsController < ApplicationController
    def new
      # If user isnt logged in dont let him enter the form
    end

    def create
      # Confirm user is logged in
      return false unless session["warden.user.user.key"][0][0]

      # Store images. If no images provided, it isn't an error. Continue storing data
      logo_url = Image.store(:logo, image_store_params[:logo])
      venue_logo_url = Image.store(:venue_logo, image_store_params[:venue_logo])
      profile_picture_url = Image.store(:tournament_profile_picture, image_store_params[:profile_picture])


      @user = User.find(session["warden.user.user.key"][0][0])
      if @user == false
        render :new # TODO: Take user to appropriate view if they are logged out
        return
      end

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
                                    :venue_logo => venue_logo_url
                                   })


      @tournament.save
    end

    private 

    def image_store_params
      params.permit(
                :logo,
                :venue_logo,
                :profile_picture
      )
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
          :private_event
      )
    end
end
