Given(/^I am signed in as (.*)$/) do |name|
  if name == "an instructor"
    @instructor = Fabricate(:instructor)
    sign_into_github_as(@instructor.github_username, @instructor.github_uid)
    visit '/users/auth/github'
  elsif name == "a student"
    @student = Fabricate.build(:student)
    sign_into_github_as(@student.github_username, @student.github_uid)
    visit '/users/auth/github'
  else
    @student = User.where(name: name).first
    sign_into_github_as(@student.github_username, @student.github_uid)
    visit '/users/auth/github'
  end
end

Given(/^I am signed in to Github as "(.*?)"$/) do |username|
  sign_into_github_as(username)
end

def sign_into_github_as(username, uid = nil)
  if uid.nil?
    user = User.find_by_github_username(username)
    uid = user.try(:github_uid) || '12345'
  end
  OmniAuth.config.add_mock(:github, {
    uid: uid,
    credentials: {
      token: "d141ef15f79ca4c6f43a8c688e0434648f277f20",
    },
    info: {
      nickname: username,
      email: "#{username}smith@example.com",
      name: "#{username.capitalize} Smith",
      image: "http://avatars.github.com/#{username}",
    },
    extra: {
      raw_info: {
        location: 'San Francisco',
        gravatar_id: '123456789'
      }
    }
  })
end
