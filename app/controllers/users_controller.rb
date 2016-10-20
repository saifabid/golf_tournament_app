rclass UsersController < ApplicationController
  def index
    # @users = User.all
  end

  def new
    # @user = User.new
  end

  def create
    # logger.debug "debugging create"
    # logger.debug "user #{params[:user][:first_name]}"

    # if params[:user][:password] == params[:user][:confirm_password]
    #   puts ("true")
    # else
    #   puts("false")
    # end

    render plain: params[:user].inspect
  end

  def show
    # before_action :authenticate_user
  end

  def edit
    # before_action :authenticate_user
  end

  def update
    # before_action :authenticate_user
  end

  def destroy
    # before_action :authenticate_user
  end

  # def signin 
  # end

  # def fp
  #   # render plain: params[:forgot_password].inspect
  # end
end
