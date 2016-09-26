# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
##################################
#
# Seeding mock data
#
# Useful commands
##################################
# rake db:seed
# rake db:reset
##################################
require 'date'

Tournament.create({
	title: 'Golfers2k18',
	description: '2k18 golfer lorem ipsum',
	start_date: DateTime.new(2018,1,2,4,5,6),
	end_date: DateTime.new(2018,1,3,4,5,6)
})

Tournament.create({
	title: 'Golfers2k16',
	description: 'This is some golfer lorem ipsum',
	start_date: DateTime.new(2016,10,1,4,5,6),
	end_date: DateTime.new(2016,10,2,4,5,6)
})

Tournament.create({
	title: 'Golfers2k17',
	description: '2k17 golfer lorem ipsum',
	start_date: DateTime.new(2017,1,2,4,5,6),
	end_date: DateTime.new(2017,1,3,4,5,6)
})

Tournament.create({
	title: 'Golfers2k15',
	description: '2k15 golfer lorem ipsum',
	start_date: DateTime.new(2015,1,2,4,5,6),
	end_date: DateTime.new(2015,1,3,4,5,6)
})
