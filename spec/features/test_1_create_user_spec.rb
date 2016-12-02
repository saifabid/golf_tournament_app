require "spec_helper"
require 'securerandom'

describe "Create Player", :type => :feature do
	it "should sign up through sign up page" do
		visit "https://golf-tournament-app.herokuapp.com/"
		# visit "http://localhost:3000/"
		sleep 2
		page.click_on('Login/Register')
		sleep 2
		page.click_on('Sign up')
		sleep 2
		@email = 'zephyr+' + SecureRandom.hex(3) + SecureRandom.hex(3) + '@test.com'
		fill_in 'user_email', :with => @email
		fill_in 'user_password', :with => "testytest"
		fill_in 'user_password_confirmation', :with => "testytest"
		page.find('.btn-success').click
		sleep 2
		page.should have_content('Welcome! You have signed up successfully.')
		
		# should get error message when clicking on submit without filling in first and last name
		#  BUG: this does not work###################################################
		# click_button("Submit")
		# page.should have_content("First name can't be blank")
		# page.should have_content("Last name can't be blank")
		# sleep 2

		# should see that first and last name were properly filled in
		fill_in 'account_first_name', :with => "Zephyr"	
		fill_in 'account_last_name', :with => "Testy"
		click_button("Submit")
		sleep 2
		page.should have_content('Mr. Zephyr Testy')

		#Logout
		page.click_on('Logout')
		sleep 1
		page.should have_content('Signed out successfully.')
	end
end
