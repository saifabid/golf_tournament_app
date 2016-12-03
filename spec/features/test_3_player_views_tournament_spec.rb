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

		# Access tournament event page
		page.click_on('Tournaments')
		sleep 1
		page.click_on('Integration Test Tournament')
		sleep 2
		page.should have_content('Integration Test Tournament')
		page.should have_content('Description: This is the integration test tourny description')
		page.should have_content('Player Tickets Remaining: 10')
		page.should have_content('Spectator Tickets Remaining: 10')
		page.should have_content('Dinner Tickets Remaining: 10')

		# View Agenda items
		click_button('Agenda')
		sleep 1
		page.should have_content('Integration Agenda 1')
		# page.should have_content('Integration Agenda description 1')
		page.should have_content('Integration Agenda 2')
		# page.should have_content('Integration Agenda description 2')
		page.evaluate_script('window.history.back()')

		# View Features
		click_button('Features')
		sleep 1
		page.should have_content('Integration Feature 1')
		page.should have_content('Integration Feature 1 description')
		page.should have_content('Integration Feature 2')
		page.should have_content('Integration Feature 2 description')
		page.evaluate_script('window.history.back()')

		# View Sponsors
		click_button('Sponsors')
		sleep 1
		page.should have_content('Gold company name 1')
		page.should have_content('Gold company name 2')
		page.should have_content('Silver company name 1')
		page.evaluate_script('window.history.back()')

		# View Information
		click_button('Information')
		sleep 1
		page.should have_content('Venue Information')
		page.should have_content('Integration Venue Name')
		page.should have_content('Located @ 45 St George St, Toronto, ON, Canada!')
		page.should have_content('Visit us @ www.nevergetoveryou.com')
		page.should have_content('Need to contact us? 647-939-9999')
		page.should have_content('Organizer Information')
		page.should have_content('Name: Mr. Tyrone')
		page.should have_content('Email: tyrone@test.com')
		page.evaluate_script('window.history.back()')

		#Logout
		page.click_on('Logout')
		sleep 1
		page.should have_content('Signed out successfully.')
	end
end