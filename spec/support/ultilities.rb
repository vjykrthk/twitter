	def full_title(title)
		base_title = "Twitter application"
		if title
			base_title + " | " + title
		else
			base_title
		end
	end

	def signin_user(user)
		puts "email: #{user.email} password: #{user.password}"
		visit signin_path
		fill_in "Email", with:user.email
		fill_in "Password", with:user.password
		click_button "Submit"
		#cookies.permanent[:remember_token] = user.remember_token
	end