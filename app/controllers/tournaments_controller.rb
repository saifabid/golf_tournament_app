class TournamentsController < ApplicationController
    def new
    end

    def create
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
