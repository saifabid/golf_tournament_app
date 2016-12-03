require "spec_helper"

describe "Create test player and organizer", :type => :feature do
	xit "run this when prod db resets" do
		visit "https://golf-tournament-app.herokuapp.com/"
		# visit "http://localhost:3000/"

		# Create test organizer
		sleep 2
		page.click_on('Login/Register')
		sleep 2
		page.click_on('Sign up')
		sleep 2
		fill_in 'user_email', :with => "test_organizer@test.com"
		fill_in 'user_password', :with => "test_organizer@test.com"
		fill_in 'user_password_confirmation', :with => "test_organizer@test.com"
		page.find('.btn-success').click
		sleep 2
		page.should have_content('Welcome! You have signed up successfully.')

		# Logout
		page.click_on('Logout')
		sleep 1
		page.should have_content('Signed out successfully.')

		# Create test player
		sleep 2
		page.click_on('Login/Register')
		sleep 2
		page.click_on('Sign up')
		sleep 2
		fill_in 'user_email', :with => "test_player@test.com"
		fill_in 'user_password', :with => "test_player@test.com"
		fill_in 'user_password_confirmation', :with => "test_player@test.com"
		page.find('.btn-success').click
		sleep 2
		page.should have_content('Welcome! You have signed up successfully.')

		# Logout
		page.click_on('Logout')
		sleep 1
		page.should have_content('Signed out successfully.')
	end
end