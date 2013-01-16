require 'spec_helper'

describe "UserPages" do
	subject { page }
	describe "Signup page" do
		before { visit signup_path }
		it { should have_content('Sign Up') }
		it { should have_selector('title', :text => full_title('Sign Up')) }      
	end
	describe "Signin" do
		before { visit signin_path }
		it { should have_content('Sign in') }
		it { should have_selector('title', :text => full_title('Sign in')) }      
		describe "Invalid signin" do
			before { click_button "Submit" }
			it "after signin" do
				should have_selector('div.alert.alert-error', :text => 'Invalid')
			end
		end
		describe "valid sigin" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with:user.email
				fill_in "Password", with:user.password
				click_button "Submit"
			end
			describe "after submission" do
				it { should have_link("Profile") }
				it { should have_link("Sign out", :href => signout_path) }
			end
		end		
	end

	describe "Signout" do
		before { visit signout_path }
		it { should have_link("Sign in", :href => signin_path) }
	end


	describe "Show page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		it { should have_selector('title', :text => user.name) }
		it { should have_selector('h2', :text => user.name) }
	end

	describe "Signup" do
		let(:submit) { "Create new user" }
		describe "with invalid data" do
			before { visit signup_path }			
			it "should not create a user in database" do
				expect { click_button submit }.not_to change(User, :count)
			end
			describe "should show errors" do
				before { click_button submit }
				it { should have_selector('div#error_explanation') }
				it { should have_selector('div.alert.alert-error', :text => "errors") }
			end
		end
		describe "with valid data" do
			before do
				visit signup_path
				fill_in "Name", with:"Vijay Kathik"
				fill_in "Email", with:"vjykrthk@gmail.com"
				fill_in "Password", with:"foobar"
				fill_in "Password confirmation", with:"foobar"
			end
			it "should create a new user in database" do
				expect { click_button submit}.to change(User, :count).by(1)
			end
			describe "after submission" do
				before { click_button submit }
				let(:user) { User.find_by_email("vjykrthk@gmail.com") }
				it { should have_content("Vijay Karthik") }
				it { should have_selector('div.alert.alert-success', :text => "welcome")}
			end
		end
	end
end
