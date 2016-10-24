Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

#use this to run stripe
#PUBLISHABLE_KEY=pk_test_6pRNASCoBOKtIshFeQd4XMUh \
#SECRET_KEY=sk_test_BQokikJOvBiI2HlWgH4olfQ2 rails s
