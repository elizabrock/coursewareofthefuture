Given(/^I am signed in as (.*)$/) do |name|
  if name == "an instructor"
    user = Fabricate(:instructor)
    user.courses << Course.active_or_future.all
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name == "a student in that course"
    user = Fabricate(:student)
    @course.users << user
    sign_into_github_as(user.github_username, user.github_uid)
  elsif name == "a student"
    user = Fabricate(:student)
    sign_into_github_as(user.github_username, user.github_uid)
  else
    user = User.where(name: name).first
    user = Fabricate(:user, github_username: name) if user.nil?
    sign_into_github_as(user.github_username, user.github_uid)
  end
  visit '/users/auth/github'
  @user = User.find_by_github_username(user.github_username)
end

Given(/^I am signed in to Github as "(.*?)"$/) do |username|
  sign_into_github_as(username)
  @username = username
end

Given(/^I am signed in to Github as "(.*?)" with a confirmed photo$/) do |username|
  sign_into_github_as(username)
  step "I go to the homepage"
  step 'I follow "Sign In with Github"'
  @user = User.find_by_github_username(username)
  step "I have a photo"
  step "my photo is confirmed"
  step 'I click "Sign Out"'
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
