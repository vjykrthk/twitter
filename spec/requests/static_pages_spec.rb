require 'spec_helper'

describe "StaticPages" do
  subject { page }
  describe "Home page" do
    before { visit home_path }
    it { should have_content('Home') }
    it { should have_selector('title', :text => full_title('Home')) }
    it { should have_selector('h2', text:'Home') }
  end

  describe "Home page after sigin in" do
    let(:user) { FactoryGirl.create(:user) }
    let(:followed_user) { FactoryGirl.create(:user) }
    let(:unfollowed_user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user:user, content:"Foo foo bar") }
    let!(:m2) { FactoryGirl.create(:micropost, user:user, content:"Bar bar") }
    let!(:followed_micropost) { FactoryGirl.create(:micropost, user:followed_user, content:"followed users post")}
    let!(:unfollowed_micropost) { FactoryGirl.create(:micropost, user:unfollowed_user, content:"followed users post")}
    before do
      signin_user(user)
      user.follow!(followed_user)
      visit home_path
    end
    it { should_not have_selector('h2', text:'Home') }
    it { should have_content(user.name) }
    it { should have_link('View my profile', href:user_path(user)) }
    it { should have_content(user.microposts.count) }
    it "should display feeds" do
      user.feed.each do |feed|
        should have_selector("li##{feed.id}", text:feed.content)
      end
    end 
    it "should delete a micropost" do
      expect { click_link "delete" }.to change(Micropost, :count).by(-1)
    end
    describe "feeds" do
      subject { user }
      its(:feed) { should include(m1) }
      its(:feed) { should include(m2) }
      its(:feed) { should include(followed_micropost) }
      its(:feed) { should_not include(unfollowed_micropost)}    
    end
    
  end

  describe "Help page" do
    before { visit help_path }
    it { should have_content('Help') }
   	it { should have_selector('title', :text => full_title('Help')) }
  end
  describe "About page" do
    before { visit about_path }
    it { should have_content('About')}
    it { should have_selector('title', :text => full_title('About')) }
  end
  describe "Contact page" do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_selector('title', :text => full_title('Contact')) }      
  end

end
