class TournamentImagesController < ApplicationController
  def upload
    uploaded_profile_picture = Image.store(:profile_picture, params[:file])
    if uploaded_profile_picture!=nil?
      respond_to do |format|
        format.json{ render :json =>uploaded_profile_picture }
    end
  end
  end
  end
