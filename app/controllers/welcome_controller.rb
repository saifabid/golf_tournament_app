require 'date'

class WelcomeController < ApplicationController
  def hello_world
  	@tournaments = Tournament.where("start_date >= NOW()").order(start_date: :asc)
  end
end
