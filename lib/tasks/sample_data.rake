namespace :db do
	desc "Fill the database with sample data"
	task populate: :environment do
		add_users
		add_microposts
		add_relationships		 
	end	
end
def add_users
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
end

def add_microposts
	users = User.all(limit:5)
	50.times do
		users.each do |user|
			user.microposts.create!(content:Faker::Lorem::sentence(7))
		end
	end
end

def add_relationships
	users = User.all
	user = users.first
	followed_users = users[3..50]
	followers = users[5..50]
	followed_users.each do |followed_user|
		user.follow!(followed_user)
	end
	followers.each do |follower|
		follower.follow!(user)
	end
end