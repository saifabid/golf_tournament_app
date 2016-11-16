require 'date'
#include Geokit::Geocoders

class WelcomeController < ApplicationController
  def hello_world
  	
    #url search params
    sortType = params[:q]

    if params[:searchTitle].blank?
      searchTitle = "%%"
    else
      searchTitle = "%"+params[:searchTitle]+"%" #for sql query LIKE clause
    end

    if params[:searchDistance].blank?
      searchDistance = 5 #5km default value
    else
      searchDistance = params[:searchDistance]
    end

    searchStart = params[:searchStart]
    clientIp = params[:client_ip]
    clientLat = params[:client_lat]
    clientLng = params[:client_lng]

  	@events = Tournament.where("start_date >= NOW()").where("is_private = '0'")
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude

      info_link = "<a href=\"/tournaments/#{event.id}\">More details / Sign Up</a>"

      marker.infowindow info_link
    end
    
    #puts MultiGeocoder.geocode('12.215.42.19') 

    #doesn't work! IP of service is dead. Need to find alternative
    #look inside of /config/initializers/geokit_config.rb , setup google api keys???

    #relevant error:
    #Ip geocoding. address: 12.215.42.19, args []
    #C:/Ruby23/lib/ruby/gems/2.3.0/gems/geokit-1.10.0/lib/geokit/geocoders.rb:141: wa
    #rning: constant Geokit::Geocoders::Geocoder::TimeoutError is deprecated
    #Caught an error during Ip geocoding call: Failed to open TCP connection to api.h
    #ostip.info:80 (getaddrinfo: No such host is known. )
    
    #alternative is to get the geo lat/lng from JS call in frontend
    
    # https://github.com/geokit/geokit-rails
    # Caveat notes that not able to do a where clause, therefore can't get descending locations
    # Temp fix : Able to view by distance whats around you using the IP
    # puts('------------')
    # puts 'client_ip'
    # puts params[:client_ip]
    # puts('------------')

  	@state = params[:state]
  	if sortType == "1"
	  	@tournaments = Tournament.where("start_date >= ?", searchStart).where("name LIKE ?", searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(start_date: :asc)
  	elsif sortType == "2"
  		@tournaments = Tournament.where("start_date >= ?", searchStart).where("name LIKE ?", searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(start_date: :desc)
  	elsif sortType == "3"
  		@tournaments = Tournament.where("start_date >= ?", searchStart).where("name LIKE ?", searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(name: :asc)
  	elsif sortType == "4"
  		@tournaments = Tournament.where("start_date >= ?", searchStart).where("name LIKE ?", searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng]).order(name: :desc)
    elsif sortType == "5"
      #TODO: .order(distance: :desc) (unknown column 'distance', add to model???)
      @tournaments = Tournament.where("start_date >= ?", searchStart).where("name LIKE ?", searchTitle).where("is_private = '0'").within(searchDistance, :origin => [clientLat,clientLng])
  	else
	  	@tournaments = Tournament.where("start_date >= NOW()").where("is_private = '0'").order(start_date: :asc)
		end

  end
end
