require "spec_helper"

describe "Create Tournament", :type => :feature do
	it "should create a tournament with the correct fields" do
		visit "https://golf-tournament-app.herokuapp.com/"
		# Login as Organizer
		sleep 2
		page.click_on('Login/Register')
		sleep 2
		fill_in 'user_email', :with => 'test_organizer@test.com'
		fill_in 'user_password', :with => 'test_organizer@test.com'
		click_button('Log in')
		sleep 2
		page.should have_content('Signed in successfully.')

		# Create Tournament
		page.click_on('Create Tournament')
		# Should see error messages with fields not filled in
		click_button('Continue')
		page.should have_content('Name can\'t be blank')
		page.should have_content('Venue address can\'t be blank')
		page.should have_content('Contact name can\'t be blank')
		page.should have_content('Contact email can\'t be blank')
		page.should have_content('Total player tickets is not a number')
		page.should have_content('Total audience tickets is not a number')
		page.should have_content('Total dinner tickets is not a number')
		page.should have_content('Player price is not a number')
		page.should have_content('Spectator price is not a number')
		page.should have_content('Dinner price is not a number')
		page.should have_content('Foursome price is not a number')

	end
end