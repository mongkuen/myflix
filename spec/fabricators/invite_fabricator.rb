Fabricator(:invite) do
  email { Faker::Internet.email }
  name { Faker::Name.name }
  message { Faker::Lorem.paragraph }
  user { Fabricate(:user) }
  token { SecureRandom.urlsafe_base64 }
end
