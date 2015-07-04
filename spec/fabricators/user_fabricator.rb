Fabricator(:user) do
  email { Faker::Internet.email }
  full_name { Faker::Name.name }
  password { Faker::Lorem.word }
end

Fabricator(:admin, from: :user) do
  role { User.roles[:admin] }
end
