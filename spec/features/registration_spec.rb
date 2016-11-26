require "spec_helper"

# this is a test
describe "User Registers", :type => :feature do 
	it "should go to sign_in page and click sign up" do
		visit "https://golf-tournament-app.herokuapp.com/"
		page.click_on('Login/Register')
		sleep 2
	end
end
