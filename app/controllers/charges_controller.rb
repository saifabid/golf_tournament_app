class ChargesController < ApplicationController
   def new
	@amount = params[:amount]
	@amountd = @amount * 0.01
	@transaction_id= params[:transaction_id]
   end

   def create
     #getting transaction_id
	     

     # Amount in cents
     @amount = 100

     customer = Stripe::Customer.create(
       :email => params[:stripeEmail],
       :source  => params[:stripeToken]
     )

     charge = Stripe::Charge.create(
       :customer    => customer.id,
       :amount      => @amount,
       :description => 'Rails Stripe customer',
       :currency    => 'usd'
     )

   rescue Stripe::CardError => e
     flash[:error] = e.message
     redirect_to new_charge_path
   end
end
