class AccountsController < ApplicationController
  def create
    @user = User.find(current_user.id)
    @account = @user.account.new account_params
    @account.save
  end

   def account_params
     params.require(:account).permit(:user_id, :prefix, :first_name, :middle_name, :last_name, :suffix, :home_adr1, :home_adr2, :home_city, :home_province, :home_code, :home_country, :bill_adr1, :bill_adr2, :bill_city, :bill_province, :bill_code, :bill_country, :gender, :birth, :mobile_phone, :is_home)
   	end
end