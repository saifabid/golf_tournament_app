require 'date'
#include Geokit::Geocoders

class WelcomeController < ApplicationController
  def hello_world
  	
    #url search params
    sortType = params[:q]
    title = ActiveRecord::Base::sanitize(params[:searchTitle])
    searchStart = ActiveRecord::Base::sanitize(params[:searchStart])
    searchEnd = ActiveRecord::Base::sanitize(params[:searchEnd])
    searchDistance = ActiveRecord::Base::sanitize(params[:searchDistance])
    clientIp = ActiveRecord::Base::sanitize(params[:client_ip])

    #puts sortType
    #puts title
    #puts searchStart
    #puts searchEnd
    #puts searchDistance
    #puts clientIp


  	@events = Tournament.where("start_date >= NOW()").where("is_private = '0'")
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
      marker.infowindow event.details
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
    
    
    # https://github.com/geokit/geokit-rails
    # Caveat notes that not able to do a where clause, therefore can't get descending locations
    # Temp fix : Able to view by distance whats around you using the IP
    # puts('------------')
    # puts 'client_ip'
    # puts params[:client_ip]
    # puts('------------')

  	@state = params[:state]
  	if sortType == "1"
	  	@tournaments = Tournament.where("start_date >= ?", searchStart).where("is_private = '0'").order(start_date: :asc)
  	elsif sortType == "2"
  		@tournaments = Tournament.where("start_date >= NOW()").where("is_private = '0'").order(start_date: :desc)
  	elsif sortType == "3"
  		@tournaments = Tournament.where("start_date >= NOW()").where("is_private = '0'").order(name: :asc)
  	elsif sortType == "4"
  		@tournaments = Tournament.where("start_date >= NOW()").where("is_private = '0'").order(name: :desc)
    elsif sortType == "5"
      # ToDo: Implement sort by location
      #@tournaments = Tournament.within(0.5, :origin => '21 Carlton St, Toronto, ON')
      @tournaments = Tournament.within(0.5, :origin => [43.6611,-79.3821])
  	else
	  	@tournaments = Tournament.where("start_date >= NOW()").where("is_private = '0'").order(start_date: :asc)
		end

  end
end
