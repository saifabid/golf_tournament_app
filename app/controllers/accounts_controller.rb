class AccountsController < ApplicationController
	def create
	  render plain: params[:account].inspect
	  puts "Hello there"
	  return self.error() unless session["warden.user.user.key"]
      @user = User.find(session["warden.user.user.key"][0][0])
      return self.error() unless @user

      # @account = Account.new(params[:account])
	end
end