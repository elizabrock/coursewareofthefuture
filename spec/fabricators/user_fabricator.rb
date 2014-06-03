Fabricator(:user) do
  github_uid { sequence(:uid, 12345).to_s }
  github_username { sequence(:username){ |i| "bob#{i}" } }
  github_access_token{ "d141ef15f79ca4c6f43a8c688e0434648f277f20" }
  name { Faker::Name.name }
  email{ Faker::Internet.email }
  photo { File.new(File.join(Rails.root, 'spec', 'support', 'files', 'arson_girl.jpg')) }
  photo_confirmed true
end

Fabricator(:student, from: :user) do
end

Fabricator(:instructor, from: :user) do
  instructor true
end
