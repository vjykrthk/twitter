module SessionHelper
	def signin(user)
		cookies.permanent[:remember_token] = user.remember_token
		current_user = user
		puts "siginin #{user}"
	end

	def current_user=(user)
		puts "current user #{user}"
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
		puts "current user function #{@current_user}"
		@current_user
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		current_user=nil
	end
end
