# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#Categories
mystery = Category.create(name: "Mystery")
scifi = Category.create(name: "Sci-fi")
comedy = Category.create(name: "Comedy")

#Videos
monk = Video.create(
  title: 'Monk',
  description: 'Monk, the OCD detective.',
  small_cover: File.open("#{Rails.root}/public/tmp/monk.jpg"),
  large_cover: File.open("#{Rails.root}/public/tmp/monk_large.jpg"),
  category: mystery,
  video_url: "https://s3.amazonaws.com/myflix1039/videos/sample.mp4")
family_guy = Video.create(
  title: 'Family Guy',
  description: 'Peter and his family.',
  small_cover: File.open("#{Rails.root}/public/tmp/family_guy.jpg"),
  large_cover: File.open("#{Rails.root}/public/tmp/monk_large.jpg"),
  category: comedy,
  video_url: "https://s3.amazonaws.com/myflix1039/videos/sample.mp4",
  created_at: 10.day.ago)
futurama = Video.create(
  title: 'Futurama',
  description: 'Fry and his adventures.',
  small_cover: File.open("#{Rails.root}/public/tmp/futurama.jpg"),
  large_cover: File.open("#{Rails.root}/public/tmp/monk_large.jpg"),
  category: scifi,
  video_url: "https://s3.amazonaws.com/myflix1039/videos/sample.mp4")
south_park = Video.create(
  title: 'South Park',
  description: 'Kids from South Park.',
  small_cover: File.open("#{Rails.root}/public/tmp/south_park.jpg"),
  large_cover: File.open("#{Rails.root}/public/tmp/monk_large.jpg"),
  category: comedy,
  video_url: "https://s3.amazonaws.com/myflix1039/videos/sample.mp4")

#Users
mong = User.create(email: "mongkuen.sun@gmail.com", full_name: "Mong-Kuen Sun", password: "password", role: User.roles[:admin])
adam = User.create(email: "adam@adam.com", full_name: "Adam Apple", password: "password")
bob = User.create(email: "bob@bob.com", full_name: "Bob Beet", password: "password")

#Reviews
mong_reviews_monk = Review.create(rating: 5, review: "It's great. This review should be old and at the bottom", user: mong, video: monk, created_at: 10.day.ago)
mong_reviews_futurama = Review.create(rating: 4, review: "okay", user: mong, video: futurama)

adam_reviews_monk = Review.create(rating: 4, review: "It's pretty good. This review is new and should be at the top", user: adam, video: monk)
adam_reviews_south_park = Review.create(rating: 1, review: "I hate south park", user: adam, video: south_park)

bob_reviews_family_guy = Review.create(rating: 3, review: "Not a biggest fan", user: bob, video: family_guy)

#Queue Items
mong_queue_item_1 = QueueItem.create(video: monk, user: mong, position: 1)
mong_queue_item_2 = QueueItem.create(video: family_guy, user: mong, position: 2)
mong_queue_item_3 = QueueItem.create(video: futurama, user: mong, position: 3)

adam_queue_item_1 = QueueItem.create(video: monk, user: adam, position: 1)
adam_queue_item_2 = QueueItem.create(video: futurama, user: adam, position: 2)

bob_queue_item_1 = QueueItem.create(video: monk, user: bob, position: 1)

#Followerships
mong_follows_adam = Followership.create(leader: adam, follower: mong)
mong_follows_bob = Followership.create(leader: bob, follower: mong)

adam_follows_bob = Followership.create(leader: bob, follower: adam)
adam_follows_mong = Followership.create(leader: mong, follower: adam)

bob_follows_mong = Followership.create(leader: mong, follower: bob)

#Invites
#Signing up with chris@chris.com should create only two mutual connections between chris and mong/adam
mong_invites_chris = Invite.create(user: mong, name: "Chris Carrot", email: "chris@chris.com", message: "Check out MyFlix!", token: "1111")
mong_invites_chris_again = Invite.create(user: mong, name: "Chris Carrot", email: "chris@chris.com", message: "Did you get my invite?", token: "2222")
adam_invites_chris = Invite.create(user: adam, name: "Chris Carrot", email: "chris@chris.com", message: "Beep Boop", token: "3333")
