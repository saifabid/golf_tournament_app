require 'date'

class WelcomeController < ApplicationController
  def hello_world
  	sortType = params[:q]

  	@events = Tournament.all
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.latitude
      marker.lng event.longitude
      marker.infowindow event.details
    end
    # puts('------------')
    # puts 'client_ip'
    # puts params[:client_ip]
    # puts('------------')

    # https://github.com/geokit/geokit-rails
    # Caveat notes that not able to do a where clause, therefore can't get descending locations
    # Temp fix : Able to view by distance whats around you using the IP
    @location_sort = Tournament.within(0.5, :origin => '21 Carlton St, Toronto, ON')
  	@state = params[:state]
  	if sortType == "1"
	  	@tournaments = Tournament.where("start_date >= NOW()").order(start_date: :asc)
  	elsif sortType == "2"
  		@tournaments = Tournament.where("start_date >= NOW()").order(start_date: :desc)
  	elsif sortType == "3"
  		@tournaments = Tournament.where("start_date >= NOW()").order(name: :asc)
  	elsif sortType == "4"
  		@tournaments = Tournament.where("start_date >= NOW()").order(name: :desc)
    elsif sortType == "5"
      # Need to fix
      @tournaments = Tournament.within(0.5, :origin => '21 Carlton St, Toronto, ON')
  	else
	  	@tournaments = Tournament.where("start_date >= NOW()").order(start_date: :asc)
		end

  end
end
