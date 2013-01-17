require 'spec_helper'

describe "Authentications" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  describe "Sign in required" do
	describe "Edit" do  	
		before { visit edit_user_path(user) }
		it { should have_selector('title', text:"Sign in") }
		it { should have_selector('div.alert.alert-notice') }
	end
	describe "Update" do
		before { put user_path(user) }
		specify { response.should redirect_to(signin_path) }
	end
  end

	describe "Right user should signin" do
		let(:user) { FactoryGirl.create(:user) }
		let(:wrong_user) { FactoryGirl.create(:user, name:"wronguser", email:"wronguser@gmail.com")}
		before do
			signin_user(wrong_user)
			visit edit_user_path(user)
		end
		describe "Edit" do
			before do
				signin_user(wrong_user)
				visit edit_user_path(user)
			end  	
			it { should have_selector('h2', text:"Home")}
		end
		describe "Update" do
			before { put user_path(user) }
			specify { response.should redirect_to(signin_path) }
		end	
	end

	describe "Index" do
		before { visit users_path }
		it { should have_selector('h2', text:"Sign in") }
	end
end
