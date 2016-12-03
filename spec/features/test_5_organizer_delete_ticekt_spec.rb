require "spec_helper"

describe "Organizer deletes tournament", :type => :feature do
	it "should go to dashboard to access and delete tournament" do
		visit "https://golf-tournament-app.herokuapp.com/"
		# visit "http://localhost:3000/"

		# Login as Organizer
		sleep 2
		page.click_on('Login/Register')
		sleep 2
		fill_in 'user_email', :with => 'test_organizer@test.com'
		fill_in 'user_password', :with => 'test_organizer@test.com'
		click_button('Log in')
		sleep 2
		page.should have_content('Signed in successfully.')

		page.click_on('Dashboard')
		sleep 1
		within(".mycreatedtournaments-panel") do
			find("a", :text => "Integration Test Tournament").click
		end
		sleep 1
		page.click_on('Delete Tournament')
		sleep 1
	end
end
