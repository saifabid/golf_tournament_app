class ChargesController < ApplicationController
   def new
	@amount = params[:amount]
	@amountd = @amount * 0.01
	@transaction_id= params[:transaction_id]
   end

   def create
     # Amount in cents
     @amount = 100

	Stripe.api_key = "sk_test_jZCX7Zq0KZFYjGAVtOhc58io"

	# Get the credit card details submitted by the form

     #customer = Stripe::Customer.create(
     #   :email => params[:stripeEmail],
     #   :source  => params[:stripeToken]
     #)

     charge = Stripe::Charge.create(
        #:customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
	:source => params[:stripeToken],
        :currency    => 'cad'
     ) 


   rescue Stripe::CardError => e
     flash[:error] = e.message
     redirect_to new_charge_path
   end
end
