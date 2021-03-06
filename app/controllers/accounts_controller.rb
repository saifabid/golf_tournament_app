class AccountsController < ApplicationController
  def create
  end
  
  def update
  end

  attr_accessor :user_id

  private
    def account_params
      params.require(:account).permit(:user_id, :avatar, :prefix, :first_name, :middle_name, :last_name, :suffix, :home_adr1, :home_adr2, :home_city, :home_province, :home_code, :home_country, :bill_adr1, :bill_adr2, :bill_city, :bill_province, :bill_code, :bill_country, :gender, :birth, :mobile_phone, :is_home)
    end
end