require 'spec_helper'

describe RelationshipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before { signin_user(user) }
  describe "creating a relationship with ajax" do
    it "should increment the relationship count" do
     expect { xhr :post, :create, relationship:{ followed_id:other_user.id } }.to change(Relationship, :count).by(1)
    end 
    it "should response with success" do
      xhr :post, :create, relationship:{ followed_id:other_user.id }
      response.should be_success
    end   
  end
  
  describe "destroying a relationship with ajax" do
    before { @relationships = user.relationships.create(followed_id:other_user.id) }
    it "should decrement the relationship count" do
      expect { xhr :delete, :destroy, id:@relationships.id }.to change(Relationship, :count).by(-1)
    end
    it "should response with success" do
      xhr :delete, :destroy, id:@relationships.id
      response.should be_success
    end
  end

end
