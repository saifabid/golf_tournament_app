require "spec_helper"

describe "Create Tournament", :type => :feature do
	it "should create a tournament with the correct fields" do
		# visit "https://golf-tournament-app.herokuapp.com/"
		visit "http://localhost:3000/"
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
		
		# Fill in all needed fields
		fill_in 'tournament_name', :with => "Integration Test Tournament"
		page.attach_file('tournament[logo]', Rails.root + 'spec/images/img1.jpg')
		fill_in 'tournament_details', :with =>'This is the integration test tourny description'
		check 'tournament_is_private'
		fill_in 'tournament_contact_name', :with =>'Mr. Tyrone'
		fill_in 'tournament_contact_email', :with =>'tyrone@test.com'
		fill_in 'tournament_venue_name', :with =>'Integration Venue Name'
		page.attach_file('tournament[venue_logo]', Rails.root + 'spec/images/img2.jpg')
		fill_in "autocomplete", :with => "45 St George St, Toronto, ON, Canada"
		fill_in 'tournament_venue_website', :with =>'www.nevergetoveryou.com'
		fill_in 'tournament_venue_contact_details', :with =>'647-939-9999'
		fill_in 'tournament_total_player_tickets', :with => 10
		fill_in 'tournament_total_audience_tickets', :with => 10
		fill_in 'tournament_total_dinner_tickets', :with => 10
		fill_in 'tournament_player_price', :with => 10
		fill_in 'tournament_dinner_price', :with => 10
		fill_in 'tournament_spectator_price', :with => 10
		fill_in 'tournament_foursome_price', :with => 10
		click_button('Continue')
		sleep 3

		# Add Tournament Profile Pictures
		page.should have_content('Tournament Profile Pictures')
		page.attach_file('tournament_profile_picture[image]', Rails.root + 'spec/images/img3.jpg')
		
		page.click_on('Upload Picture!')
		sleep 3
		page.attach_file('tournament_profile_picture[image]', Rails.root + 'spec/images/img4.jpg')
		page.click_on('Upload Picture!')
		sleep 3

		# # Check to see pictures have correct information
		# ####################################################################
		page.click_on('Continue')

		#Add Tournament Agenda Information
		fill_in 'tournament_event_event_name', :with => 'Integration Agenda 1' 
		fill_in 'tournament_event_description', :with => 'Integration Agenda description 1'
		select "08 AM", :from => "tournament_event_start_time_4i" 
		select "00", :from => "tournament_event_start_time_5i"
		select "09 AM", :from => "tournament_event_end_time_4i"
		select "00", :from => "tournament_event_end_time_5i"
		page.click_on('Create Tournament event')
		sleep 1

		fill_in 'tournament_event_event_name', :with => 'Integration Agenda 2' 
		fill_in 'tournament_event_description', :with => 'Integration Agenda description 2'
		select "10 AM", :from => "tournament_event_start_time_4i" 
		select "00", :from => "tournament_event_start_time_5i"
		select "11 AM", :from => "tournament_event_end_time_4i"
		select "00", :from => "tournament_event_end_time_5i"
		page.click_on('Create Tournament event')
		sleep 1

		page.click_on('Continue')
		# Ensure agenda information shows up correctly
		# ####################################################################




		# Delete tournament
	end
end
