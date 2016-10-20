class AccountsController < ApplicationController
  def create
    render plain: params[:account].inspect
    puts "Hello there"
    return self.error() unless session["warden.user.user.key"]
    @user = User.find(session["warden.user.user.key"][0][0])
    return self.error() unless @user

    @account = Account.new(account_params)
    if @account.save
      puts "Success"
      redirect_to @account
    else
      puts "Error"
    end
  end

  private
    def account_params
      params.require(:account).permit(:user_id, :prefix, :first_name, :middle_name, :last_name, :suffix, :home_adr1, :home_adr2, :home_city, :home_province, :home_code, :home_country, :bill_adr1, :bill_adr2, :bill_city, :bill_province, :bill_code, :bill_country, :gender, :birth, :mobile_phone, :is_home)
   	end
end