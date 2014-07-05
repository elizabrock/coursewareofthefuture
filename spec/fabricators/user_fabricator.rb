Fabricator(:user) do
  github_uid { sequence(:uid, 12345).to_s }
  github_username { sequence(:username){ |i| "bob#{i}" } }
  github_access_token{ ENV["GITHUB_ACCESS_TOKEN"] }
  name { Faker::Name.name }
  email{ Faker::Internet.email }
  photo { File.new(File.join(Rails.root, 'spec', 'support', 'files', 'arson_girl.jpg')) }
  photo_confirmed true
end

Fabricator(:student, from: :user) do
  instructor false
end

Fabricator(:instructor, from: :user) do
  instructor true
  github_username { "bob" }
end
