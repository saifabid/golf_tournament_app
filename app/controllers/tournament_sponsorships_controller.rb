class TournamentSponsorshipsController < ApplicationController
    def new
        @tournament_id = params[:id]
        @tournament_sponsor = TournamentSponsorship.new
    end

    def create 
        p = tournament_sponsor_params
        uploaded_logo = Image.store(:company_logo, p[:company_logo])
        if uploaded_logo.nil?
            render :new
            return
        end

        p[:company_logo] = uploaded_logo["url"]
        p[:tournament_id] = params[:tournament_id]
        @sponsor = TournamentSponsorship.new p
      
        if !@sponsor.save 
            render :new
            return 
        end

        redirect_to sprintf("/organizer_dashboard/%s", params[:tournament_id])
    end

    def tournament_sponsor_params
        # fields we want to perform any operations on on in this controller
        params.require(:tournament_sponsorship).permit(
            :sponsor_type,
            :company_name,
            :company_logo
        )
  end
end
