require 'spec_helper'

describe "User" do
	subject { @user }
	before { @user = User.new({ name:"Vijay Karthik", email:"vjykrthk@gmail.com", 
								password: "foobar", password_confirmation: "foobar"
							 })}
	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:relationships) }
	it { should respond_to(:reverse_relationships) }
	it { should respond_to(:followed_users) }
	it { should respond_to(:followers) }
	it { should respond_to(:follow!) }
	it { should respond_to(:unfollow!) }
	it { should respond_to(:following?) }
	it { should_not be_admin }


	describe "Admin attribute set to true" do
		before do
			@user.save!
			@user.toggle(:admin)
		end
		it { should be_admin }
	end

	describe "remember token" do
		before { @user.save }
		it { should respond_to(:remember_token) }
		its(:remember_token)  { should_not be_nil }
	end
	

	it { should be_valid }
	describe "email with mixed casing" do
		let(:mixed_case_email) { "VJyKrThk@GmaIL.Com" }
		it "should be saved in lower case" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == "vjykrthk@gmail.com"

		end
	end
	describe "name attribute" do
		describe "validates presence of name" do
			before { @user.name = " " }
			it { should_not be_valid }
		end
		describe "name should of valid length" do
			before { @user.name = "a" * 51 }
			it { should_not be_valid }
		end		
	end
	describe "email attribute" do
		describe "validates presence of email" do
			before { @user.email = " " }
			it { should_not be_valid }
		end
		describe "valid email formats" do
			before { @valid_emails =  %w[vjykr.thk@gmail.com vjykr.thk@gmedsa.il.com vjykr+thk@g33mail.com] }
			it "valid email formats" do
				@valid_emails.each do |valid_email|
					@user.email = valid_email
					should be_valid
				end
			end
		end
		describe "email should be unique" do
			before do 
				user_with_same_email = @user.dup
				user_with_same_email.save
			end
			it { should_not be_valid }
		end
		describe "email address should case insensitive" do
			before do 
				user_with_same_email = @user.dup
				user_with_same_email.email = @user.email.upcase
				user_with_same_email.save
			end
			it { should_not be_valid }			
		end

		describe "invalid email formats" do
			before { @invalid_emails =  %w[vjykr.thk@gmail. vjykr.thkgmedsa.il.com vjykr+thk@g33+mail.com] }
			it "invalid email formats" do
				@invalid_emails.each do |invalid_email|
					@user.email = invalid_email
					should_not be_valid
				end
			end
		end


		describe "when password is not present" do
			before { @user.password = @user.password_confirmation = " " }
			it { should_not be_valid }
		end


		describe "password and password confirmation should match" do
			before { @user.password_confirmation = "mismatch" }
			it { should_not be_valid }
		end

		describe "return value of authenticate method" do
			before { @user.save }
			let(:user_found) { User.find_by_email(@user.email) }
			describe "for valid password" do
				it { should == user_found.authenticate(@user.password) }
			end
			describe "for invalid password" do
				let(:user_not_found) { user_found.authenticate("invalid") }
				it { should_not == user_not_found }
				specify { user_not_found.should be_false }
			end
		end
	end
	describe "Edit user" do
		let(:user) { FactoryGirl.create(:user) }
		let(:new_name) { "New name" }
		let(:new_email) { "newname@example.org"}
		before do
			signin_user(user)
			visit edit_user_path(user)
		end
		it "Should update the record" do
			fill_in "Name", with:new_name
			fill_in "Email", with:new_email
			fill_in "Password", with:user.password
			fill_in  "Password confirmation", with:user.password_confirmation
			click_button "save changes"
			user.reload.name.should == new_name
		end
	end

	describe "Micropost" do
		before { @user.save }
	    let!(:older_micropost) { FactoryGirl.create(:micropost, user:@user, created_at:1.day.ago) }
	    let!(:newer_micropost) { FactoryGirl.create(:micropost, user:@user, created_at:1.hour.ago) }
	    let(:followed_user) { FactoryGirl.create(:user) }
	    let(:unfollowed_user) { FactoryGirl.create(:user) }
	    let!(:followed_post) { FactoryGirl.create(:micropost, user:followed_user) }
	    let!(:unfollowed_post) { FactoryGirl.create(:micropost, user:unfollowed_user) }
		describe "Most recent microposts should be returned first" do
			its(:microposts) { should == [newer_micropost, older_micropost] }
  		end
  		describe "status" do
  			before { @user.follow!(followed_user) }
  			its(:feed) { should include(older_micropost) }
  			its(:feed) { should include(newer_micropost) }
  			its(:feed) { should include(followed_post) }
  			its(:feed) { should_not include(unfollowed_post) }
  		end
	  	describe "When user is deleted all his micropost should be deleted" do
	  		it "assciated micropost should be deleted" do
	    		@microposts = @user.microposts.dup
	    		@user.destroy
				@microposts.each do |micropost|
	    			Micropost.find_by_id(micropost.id).should be_nil
	    		end
	    	end
	  	end
	end

	describe "User following" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			@user.save
			@user.follow!(other_user)
		end
		it { should be_following(other_user) }
		its (:followed_users) { should include(other_user) }

		describe "followers" do
			subject { other_user }
			its(:followers) { should include(@user) }
		end
		
		describe "Unfollow" do
			before { @user.unfollow!(other_user) }
			it { should_not be_following(other_user) }
			its (:followed_users) { should_not include(other_user) }
		end
	end	
end
