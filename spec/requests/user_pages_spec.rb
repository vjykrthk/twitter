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

	describe "Edit page" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			signin_user(user)
			visit edit_user_path(user)
		end
		it { should have_selector('h2', text:"Update your profile") }
		it { should have_selector('title', text:"Edit user") }
		it { should have_link('change', href:"http://gravatar.com/emails") }

		describe "Invalid information" do
			before { click_button 'save changes' }
			it { should have_content("error") }
		end
	end

	describe "Friendly forwading" do
		let(:user)  { FactoryGirl.create(:user) }
		before do 
			visit edit_user_path(user) 
			signin_user(user)
		end
		it { should have_selector('h2', text:"Update your profile") }
	end

	describe "Index" do
		let(:first_user) { FactoryGirl.create(:user) }		
		before(:all) do			
			signin_user(first_user)
			30.times do |n|
				FactoryGirl.create(:user)
			end
			visit users_path
		end
		after(:all) { User.delete_all }
		#it { should have_selector('h2', text:'All users') }
		it "should show list of all users" do
			User.paginate(page: 1).each do |user|
				page.should have_selector('li', text:user.name)
			end
		end
	end

	describe "Admin:" do
		describe "a user not admin should not see delete link" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				signin_user user
				visit users_path
			end
			it { should_not have_link("delete") }
		end

		describe "a admin user should see delete link" do
			let!(:admin) { FactoryGirl.create(:admin) }
			let!(:user) { FactoryGirl.create(:user) }
			before do
				signin_user admin
				visit users_path
			end
			it { should have_link("delete") }
			it { should_not have_link("delete", href:user_path(admin)) }
			it "should be able to delete users" do
				expect { click_link "delete" }.to change(User, :count).by(-1)
			end
		end

		# describe "non admin user should be redirected to root url" do
		# 	let(:non_admin) { FactoryGirl.create(:user) }
		# 	let(:user) { FactoryGirl.create(:user) }
		# 	before do
		# 		signin_user non_admin
		# 		delete user_path(user)
		# 	end
		# 	specify { response.should redirect_to(root_url) }
		# end

	end
end
