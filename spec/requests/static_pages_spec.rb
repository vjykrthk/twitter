require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have content 'Home'" do
      visit '/static_pages/home'
      page.should have_content('Home')
    end
    it "should have right title" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "Twitter application | Home")
    end
  end
  describe "Help page" do
    it "should have content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
   	end
   	it "should have right title" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "Twitter application | Help")
    end
  end
  describe "About page" do
    it "should have content 'About'" do
      visit '/static_pages/about'
      page.should have_content('About')
   	end
  	it "should have right title" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "Twitter application | About")
    end
  end
end
