class UsersController < ApplicationController
  def index
    # @users = User.all
  end

  def new
    # @user = User.new
  end

  def create
    logger.debug "debugging create"
    logger.debug "user #{params[:user][:first_name]}"
    render plain: params[:user].inspect
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
