# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Users
test_user = User.create(email: "mongkuen.sun@gmail.com", full_name: "Mong-Kuen Sun", password: "password")
test_user2 = User.create(email: "test2@test.com", full_name: "Bill Test", password: "password")

#Categories
mystery = Category.create(name: "Mystery")
scifi = Category.create(name: "Sci-fi")
comedy = Category.create(name: "Comedy")

#Videos
monk = Video.create(title: 'Monk', description: 'Monk, the OCD detective.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: mystery)
family_guy = Video.create(title: 'Family Guy', description: 'Peter and his family.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/family_guy.jpg', category: comedy, created_at: 10.day.ago)
futurama = Video.create(title: 'Futurama', description: 'Fry and his adventures.', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama.jpg', category: scifi)
sout_park = Video.create(title: 'South Park', description: 'Kids from South Park.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/south_park.jpg', category: comedy)

#Reviews
monk_review_1 = Review.create(rating: 5, review: "It's great. This review should be old and at the bottom", user: test_user, video: monk, created_at: 10.day.ago)
monk_review_2 = Review.create(rating: 4, review: "It's pretty good. This review is new and should be at the top", user: test_user2, video: monk)
family_guy_review_1 = Review.create(rating: 3, review: "It's okay", user: test_user, video: family_guy)
family_guy_review_2 = Review.create(rating: 4, review: "It's pretty good", user: test_user2, video: family_guy)

#QueueItems
item_1 = QueueItem.create(video: monk, user: test_user, position: 1)
item_2 = QueueItem.create(video: family_guy, user: test_user, position: 2)
item_3 = QueueItem.create(video: futurama, user: test_user, position: 3)
