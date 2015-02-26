Fabricator(:review) do
  rating { Faker::Number.between(from = 1, to = 5) }
  review { Faker::Lorem.words(5).join(" ") }
end
