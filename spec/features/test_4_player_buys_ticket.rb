require "spec_helper"

describe "Player checks out tournament", :type => :feature do
	it "should go to event page and view thigns on page" do
		# Login
		visit "https://golf-tournament-app.herokuapp.com/"
		# visit "http://localhost:3000/"
		sleep 2
		page.click_on('Login/Register')
		sleep 2
		fill_in 'user_email', :with => 'test_player@test.com'
		fill_in 'user_password', :with => 'test_player@test.com'
		click_button('Log in')
		sleep 2
		page.should have_content('Signed in successfully.')

		# Go to Tournament
		page.click_on('Tournaments')
		sleep 1
		page.click_on('Integration Test Tournament')
		sleep 2

		#Buy ticket
		click_button('Buy Tickets')
		fill_in 'foursome_tickets', :with => 1
		click_button('Save')
		sleep 1
		page.click_on('Pay with Card')
		sleep 2
		stripe_iframe = all('iframe[name=stripe_checkout_app]').last
	  Capybara.within_frame stripe_iframe do
	    find(:css, "input[type='email']").set("testytest@test.com")
	    find(:css, "input[placeholder='Card number']").set(4242424242424242)
	    find(:css, "input[placeholder='MM / YY']").set(222)
	    find(:css, "input[placeholder='CVC']").set(333)
	    click_button('Pay')
	  end
	  sleep 4

	  # Get transaction number
	  tdArr = []
	  page.all('.table td').each do |td|
	  	if td.text != 'Download'
	  		tdArr.push(td.text)
	  	end
	  end

	  @ticket_number = tdArr[0]
	  puts "@ticket_number"
	  puts @ticket_number

	  visit "https://golf-tournament-app.herokuapp.com/"
		# visit "http://localhost:3000/"
		# Go to Tournament
		page.click_on('Tournaments')
		sleep 1
		page.click_on('Integration Test Tournament')
		sleep 2
		page.execute_script "window.scrollBy(0,10000)"
		sleep 1
		page.click_on('Check In')
		sleep 1
		page.execute_script "window.scrollBy(0,10000)"
		page.should have_content('true')
	end
end