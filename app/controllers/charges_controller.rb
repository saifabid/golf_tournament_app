class ChargesController < ApplicationController
   def new
	@amount = params[:amount]
	@amountd = @amount * 0.01
  @signup_params= params[:signup_params]

   end

   def create
     # Amount in cents
     @amount = params[:amount]

	Stripe.api_key = Rails.application.secrets.stripe_secret_key

	# Get the credit card details submitted by the form

     #customer = Stripe::Customer.create(
     #   :email => params[:stripeEmail],
     #   :source  => params[:stripeToken]
     #)
begin
     charge = Stripe::Charge.create(
        #:customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
	:source => params[:stripeToken],
        :currency    => 'cad'
     )


   rescue Stripe::CardError => e
     flash[:error] = e.message
     redirect_to new_charge_path,  signup_params:params[:signup_params], amount:params[:amount]
end

   redirect_to signup_params=params[:signup_params], amount:params[:amount]

end
end