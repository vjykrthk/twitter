class MicropostsController < ApplicationController
	before_filter :user_signed_in
	include SessionHelper
	def create
		puts params
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save		
			flash[:success] = "You have created a micropost"
			redirect_back_or_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end	
	end

	def destroy
		current_user.microposts.find_by_id(params[:id]).destroy
		redirect_to root_url
	end

end