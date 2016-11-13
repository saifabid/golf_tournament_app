class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
    @user = User.find(current_user.id)
    @account = Account.new(image_store)
    @account.user_id = current_user.id
    @user.account_id = @account.id
    @account.save

    if @account.errors.any?
      flash[:notice] = @account.errors.full_messages.to_sentence
      render :new
    else
      redirect_to @user
    end
  end

  def show
    @user = User.find(current_user.id)
    @account = Account.find_by!(user_id: current_user.id)
  end

  def edit
    @user = User.find(current_user.id)
    @account = Account.find_by!(user_id: current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    @account = Account.find_by!(user_id: current_user.id)
    @account.update(image_store)

    if @account.errors.any?
      flash[:notice] = @account.errors.full_messages.to_sentence()
      render :new
    else
      redirect_to @user
    end
  end

  def image_store
    params = account_params
    profile_picture = Image.store(:profile_pic, params[:profile_pic])
    if profile_picture.nil?
      profile_picture = {}
    end
    params[:profile_pic] = profile_picture['url']
    return params
  end

  def destroy
  end

  attr_accessor :account_id

  private
    def account_params
      params.require(:account).permit(:user_id, :profile_pic, :prefix, :first_name, :middle_name, :last_name, :suffix, :home_adr1, :home_adr2, :home_city, :home_province, :home_code, :home_country, :bill_adr1, :bill_adr2, :bill_city, :bill_province, :bill_code, :bill_country, :gender, :birth, :mobile_phone, :is_home)
    end    
end
