class TournamentSponsorshipsController < ApplicationController
    before_action :check_user_auth
    before_action :check_tournament_organizer, only: [:index, :create, :destroy]

    def check_tournament_organizer
        if !Person.where(sprintf("user_id = %d AND tournament_id = %d AND is_organizer = 1", current_user.id, params[:tournament_id])).exists?
         flash[:error] = "Cannot Update Tournament"
         redirect_to "/"
         return
        end
    end

    def new
        @tournament= Tournament.find(params[:tournament_id])
        @tournament.tournament_sponsorships.build
    end

    def index
    end

    def create
        @tournament= Tournament.find(params[:tournament_id])
        if @tournament.errors.any?
          flash[:error] = @tournament.errors.full_messages.to_sentence
          puts flash[:error]
          render :new
          return
        end

        p = tournament_sponsor_params
        uploaded_logo = Image.store(:company_logo, p[:company_logo])
        if uploaded_logo.nil?
          uploaded_logo = {}
        end

        p[:company_logo] = uploaded_logo["url"]
        p[:tournament_id] = params[:tournament_id]

        @tournament_sponsorship = @tournament.tournament_sponsorships.create(p)
        if @tournament_sponsorship.errors.any?
          flash[:error] = @tournament_sponsorship.errors.full_messages.to_sentence
          puts flash[:error]
          render :new
          return
        end

        redirect_to new_tournament_tournament_sponsorship_path(@tournament.id)
    end

    def destroy
        TournamentSponsorship.find(params[:id]).destroy
        redirect_to new_tournament_tournament_sponsorship_path(Tournament.find(params[:tournament_id]))
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
