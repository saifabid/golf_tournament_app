class UsersController < ApplicationController
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

    # render plain: params[:user].inspect
  end

  def show
    @user = User.find(current_user.id)
    # puts(@user.account.)
    @account = Account.find(current_user.id)
    # puts(@account.first_name)
    # @data = params[:account]
    # before_action :authenticate_user
  end

  def edit
    # before_action :authenticate_user
  end

  def update
    # before_action :authenticate_user
    @user = User.find(current_user.id)
    @account = Account.find(current_user.id)
    if @account.update(account_params)
      redirect_to @user
    else
      redirect_to edit_user_registration
    end
  end

  def destroy
    # before_action :authenticate_user
  end

  private
    def account_params
      params.require(:account).permit(:user_id, :avatar, :prefix, :first_name, :middle_name, :last_name, :suffix, :home_adr1, :home_adr2, :home_city, :home_province, :home_code, :home_country, :bill_adr1, :bill_adr2, :bill_city, :bill_province, :bill_code, :bill_country, :gender, :birth, :mobile_phone, :is_home)
    end
end
