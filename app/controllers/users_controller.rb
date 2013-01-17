class UsersController < ApplicationController
	include SessionHelper
	before_filter :user_signed_in, only:[:index, :edit, :update, :destroy]
	before_filter :check_right_user, only:[:edit, :update]
	before_filter :admin_user, only:[:destroy]
	def new
		@user = User.new
	end
	def index
		@users = User.paginate(page: params[:page])
	end
	def show
		@user = User.find_by_id(params[:id])
	end
	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "#{@user.name} welcome to twitter"
			redirect_to @user
		else
			render 'new'
		end
	end
	def edit		
	end
	def update
		if @user.update_attributes(params[:user])
			signin @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User successfully deleted"
		redirect_to users_url
	end

	private
		def user_signed_in
			puts signed_in?
			unless signed_in?
				store_location
				redirect_to signin_path, notice:"Please sign in"
			end

		end
		def check_right_user
			@user = User.find(params[:id])
			redirect_to root_url unless correct_user(@user)
		end
		def admin_user
			puts current_user.admin?
			redirect_to root_url unless current_user.admin?
		end
end
