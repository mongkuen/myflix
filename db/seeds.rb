# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: 'Monk', description: 'Monk, the OCD detective.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg')

Video.create(title: 'Family Guy', description: 'Peter and his family.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy.jpg')

Video.create(title: 'Futurama', description: 'Fry and his adventures.', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama.jpg')

Video.create(title: 'South Park', description: 'Kids from South Park.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/south_park.jpg')
