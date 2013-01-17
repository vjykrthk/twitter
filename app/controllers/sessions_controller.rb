class SessionsController < ApplicationController
	include SessionHelper
	def new
	end

	def create
		user = User.find_by_email(params[:sessions][:email])
		if user && user.authenticate(params[:sessions][:password])
			signin(user)
			redirect_back_or_to user	
		else
			flash[:error] = "Invalid email/password"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
