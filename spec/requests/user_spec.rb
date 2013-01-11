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


		#describe "when password is not present" do
			#before { @user.password = @user.password_confirmation = " " }
			#it { should_not be_valid }
		#end


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
	
end
