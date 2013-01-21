namespace :db do
	desc "Fill the database with sample data"
	task populate: :environment do
		user = User.create!( { name:"Vijay Karthik P", 
			email: "vjykrthk@gmail.com", 
			password:"foobar", 
			password_confirmation:"foobar"})
		user.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			User.create!({ name:name, email:email, password:"foobar", password_confirmation:"foobar" })
		end
		users = User.all(limit:5)
		50.times do
			users.each do |user|
				user.microposts.create!(content:Faker::Lorem::sentence(7))
			end
		end 
	end
end