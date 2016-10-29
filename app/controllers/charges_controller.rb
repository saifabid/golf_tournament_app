class ChargesController < ApplicationController
   def new
	@amount = params[:amount]
	@transaction_id= params[:transaction_id]
   end

   def create
     #transaction_id
     #transaction_id= params[:transaction_id]
     @transaction_id= 3
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
