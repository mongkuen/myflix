Fabricator(:video) do
  title { Faker::Lorem.words(2).join(" ") }
  description { Faker::Lorem.words(5).join (" ") }
  category { Fabricate(:category) }
  large_cover {
    ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join("spec/fabricators/fixtures/large_cover.jpg")),
      :filename => File.basename(File.new(Rails.root.join("spec/fabricators/fixtures/large_cover.jpg")))
    )
  }
  small_cover {
    ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join("spec/fabricators/fixtures/small_cover.jpg")),
      :filename => File.basename(File.new(Rails.root.join("spec/fabricators/fixtures/small_cover.jpg")))
    )
  }
  video_url { Faker::Lorem.word }
end
