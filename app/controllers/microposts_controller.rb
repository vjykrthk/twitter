class MicropostsController < ApplicationController
	before_filter :user_signed_in
	include SessionHelper
	def create
		@micropost = current_user.microposts.build(content:params[:micropost][:content])
		if @micropost.save		
			flash[:success] = "You have created a micropost"
			redirect_to root_url
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