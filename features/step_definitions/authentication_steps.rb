Given(/^I am signed in as (.*)$/) do |name|
  if name == "an instructor"
    @instructor = Fabricate(:instructor)
    visit new_instructor_session_path
    fill_in "Email", with: @instructor.email
    fill_in "Password", with: "password"
    click_button "Login"
  elsif name == "a student"
    @student = Fabricate.build(:student)
    sign_into_github_as(@student.github_username, @student.github_uid)
    visit '/students/auth/github'
    @student = Student.last
  else
    @student = Student.where(name: name).first
    sign_into_github_as(@student.github_username, @student.github_uid)
    visit '/students/auth/github'
  end
end

Given(/^I am signed in to Github as "(.*?)"$/) do |username|
  sign_into_github_as(username)
end

def sign_into_github_as(username, uid = nil)
  uid ||= '12345'
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
