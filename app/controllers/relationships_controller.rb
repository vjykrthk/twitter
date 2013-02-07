class RelationshipsController < ApplicationController
	include SessionHelper
	before_filter :user_signed_in
	
	def create
		@user = User.find_by_id(params[:relationship][:followed_id])
		current_user.follow!(@user)		
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end


	def destroy
		@relationship = current_user.relationships.find_by_id(params[:id])
		@user = User.find_by_id(@relationship.followed_id)
		@relationship.destroy
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end