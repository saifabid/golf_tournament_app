require 'date'
#include Geokit::Geocoders

class WelcomeController < ApplicationController
  def hello_world
  	
    #url search params
    sortType = params[:q]

    if params[:searchTitle].blank?
      @searchTitleFlash = ""
      @searchTitle = "%%"
    else
      @searchTitleFlash = params[:searchTitle]
      @searchTitle = "%"+params[:searchTitle]+"%" #for sql query LIKE clause
    end

    if params[:searchDistance].blank?
      @searchDistanceFlash = ""
      searchDistance = 50 #50km default value
    else
      @searchDistanceFlash = params[:searchDistance]
      searchDistance = params[:searchDistance]
    end

    if params[:searchStart].blank? or params[:searchStart] < Time.now.to_s(:db)
      @searchStartFlash = ""
      searchStart = Time.now.to_s(:db) #NOW
    else
      @searchStartFlash = params[:searchStart]
      searchStart = params[:searchStart]
    end

    searchStart = params[:searchStart]

    if params[:client_lat].blank? or params[:client_lng].blank?
      #if we were unable to get the lat & long, hard code to SF building as centre point
      clientLat = session[:client_lat]
      clientLng = session[:client_lng]
    else
      clientLat = params[:client_lat]
      clientLng = params[:client_lng]
      session[:client_lat] = clientLat
      session[:client_lng] = clientLng
    end

  	@events = Tournament.where("start_date >= NOW()").where("is_private = '0'")
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude

      signup_link = "<a href=\"/tournaments/#{event.id}\">More details / Sign Up</a>"
      window_content = event.name + "<br>"
      window_content = window_content + signup_link

      marker.infowindow window_content
    end

  	@state = params[:state]
  	if sortType == "1"
	  	@tournaments = Tournament.where("start_date >= NOW()").where("start_date >= ?", searchStart).where("name LIKE ?", @searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(start_date: :asc)
  	elsif sortType == "2"
  		@tournaments = Tournament.where("start_date >= NOW()").where("start_date >= ?", searchStart).where("name LIKE ?", @searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(start_date: :desc)
  	elsif sortType == "3"
  		@tournaments = Tournament.where("start_date >= NOW()").where("start_date >= ?", searchStart).where("name LIKE ?", @searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(name: :asc)
  	elsif sortType == "4"
  		@tournaments = Tournament.where("start_date >= NOW()").where("start_date >= ?", searchStart).where("name LIKE ?", @searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(name: :desc)
    elsif sortType == "5"
      @tournaments = Tournament.where("start_date >= NOW()").where("start_date >= ?", searchStart).where("name LIKE ?", @searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).by_distance(:origin => [clientLat,clientLng])
  	else
      @tournaments = Tournament.where("start_date >= NOW()").where("name LIKE ?", @searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(start_date: :asc)
		end


    @form_url = '/'

    @top_ids = Person.group(:tournament_id).count
    @top_ids = Hash[@top_ids.sort_by{|k, v| v}.reverse]
    @top_ids = @top_ids.keys
    @top_ids = @top_ids.first(5)

    @top_tourneys = []

    @top_ids.each do |id|
      @top_tourneys.push(Tournament.find(id))
    end
  end
end
