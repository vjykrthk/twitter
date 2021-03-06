module SessionHelper
	def signin(user)
		cookies.permanent[:remember_token] = user.remember_token
		current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		current_user=nil
	end

	def correct_user(user)
		user == current_user
	end

	def redirect_back_or_to(default)
		redirect_to (session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end

	def user_signed_in
		unless signed_in?
			store_location
			redirect_to signin_path, notice:"Please sign in"
		end
	end
end
