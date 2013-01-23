require 'spec_helper'

describe Relationship do
	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }
	let(:relationship) { follower.relationships.build(followed_id:followed.id) }
	subject { relationship }
	it { should be_valid }
	it { should respond_to(:follower) }
	it { should respond_to(:followed) }

	its(:follower) { should == follower }
	its(:followed) { should == followed }
	describe "Accessible attributes" do
		it "should raise an mass assignment security error" do
			expect { Relationship.new(follower_id:follower.id) }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
	describe "Validation" do
		describe "follower id should not be blank" do
			before { relationship.follower_id = nil }
			it { should_not be_valid }
		end

		describe "follower id should not be blank" do
			before { relationship.follower_id = nil }
			it { should_not be_valid }
		end
	end


end
