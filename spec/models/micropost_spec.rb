require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do
  	#@micropost = Micropost.new({ content:"Lorem ipusm", user_id:user })
  	@micropost = user.microposts.build({ content:"Lorem ipsum" })
  end
  subject { @micropost }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:in_reply_to) }
  its(:user) { should == user }

  describe "Accessible attribute" do
  	it "should raise error when user_id is accessed" do
  		expect do
  			Micropost.create!({ user_id:user.id })
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "When user_id is not present it should not be valid" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "Content should before less than 140 characters" do
    before { @micropost.content = "a"*141 }
    it { should_not be_valid }
  end


end
