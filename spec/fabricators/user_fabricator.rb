Fabricator(:user) do
  github_uid { sequence(:uid, 12345).to_s }
  github_username { sequence(:username){ |i| "bob#{i}" } }
  name { Faker::Name.name }
  email{ Faker::Internet.email }
end

Fabricator(:student, from: :user) do
end

Fabricator(:instructor, from: :user) do
  instructor true
end
