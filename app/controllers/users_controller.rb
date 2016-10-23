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
    @user = User.find(current_user.id)
    @account = Account.new(account_params)
    @account.user_id = current_user.id
    @user.account_id = @account.id
    if @account.save!
      redirect_to @user
    else
      redirect_to new_user_path
    end
  end

  def show
    @user = User.find(current_user.id)
    @account = Account.find_by!(user_id: current_user.id)
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
    @account = Account.find_by!(user_id: current_user.id)
    if @account.update(account_params)
      redirect_to @user
    else
      redirect_to edit_user_path
    end
  end

  def destroy
    # before_action :authenticate_user
  end

  attr_accessor :account_id

  private
    def user_params
      params.require(:user).permit(:user_id, :avatar, :prefix, :first_name, :middle_name, :last_name, :suffix, :home_adr1, :home_adr2, :home_city, :home_province, :home_code, :home_country, :bill_adr1, :bill_adr2, :bill_city, :bill_province, :bill_code, :bill_country, :gender, :birth, :mobile_phone, :is_home)
    end

    def account_params
      params.require(:account).permit(:user_id, :avatar, :prefix, :first_name, :middle_name, :last_name, :suffix, :home_adr1, :home_adr2, :home_city, :home_province, :home_code, :home_country, :bill_adr1, :bill_adr2, :bill_city, :bill_province, :bill_code, :bill_country, :gender, :birth, :mobile_phone, :is_home)
    end    
end
