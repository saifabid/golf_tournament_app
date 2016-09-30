require 'date'

class WelcomeController < ApplicationController
  def hello_world

  	sortType = params[:q]

  	if  sortType == "1"
	  	@tournaments = Tournament.where("start_date >= NOW()").order(start_date: :asc)
  	elsif sortType == "2"
  		@tournaments = Tournament.where("start_date >= NOW()").order(start_date: :desc)
  	elsif sortType == "3"
  		@tournaments = Tournament.where("start_date >= NOW()").order(title: :asc)
  	elsif sortType == "4"
  		@tournaments = Tournament.where("start_date >= NOW()").order(title: :desc)
  	else
	  	@tournaments = Tournament.where("start_date >= NOW()").order(start_date: :asc)
	end
  end

end
