module Features
  module AuthenticationHelpers

    def signin_as(user_type, options = {})
      Fabricate(:instructor) unless User.all.length > 1
      user = (user_type.is_a? Symbol) ? Fabricate(user_type, options) : user_type
      sign_into_github_as(user)
      visit user_omniauth_authorize_path("github")
      if user.instructor?
        visit course_path(user.courses.first) unless user.courses.empty?
      end
      user
    end

    def sign_into_github_as(user_or_username, token: nil)
      token = user_or_username.try(:github_access_token) || token || ENV["GITHUB_ACCESS_TOKEN"]
      username = user_or_username.try(:github_username) || user_or_username
      name = user_or_username.try(:name) || "#{username.capitalize} Smith"
      uid = user_or_username.try(:github_uid) || '12345'
      email = user_or_username.try(:email) || "#{username}smith@example.com"

      photo_url = "https://avatars.github.com/#{uid}?s=460"
      @default_image ||= File.read(Rails.root.join('spec', 'support', 'files', 'arson_girl.jpg'))

      stub_request(:get, photo_url).
        to_return( body: @default_image,
                  :status   => 200,
                  :headers  => { 'Content-Type' => "image/jpeg; charset=UTF-8" } )

      OmniAuth.config.add_mock(:github, {
        uid: uid,
        credentials: {
          token: token
        },
        info: {
          nickname: username,
          email: email,
          name: name,
          image: photo_url,
        },
        extra: {
          raw_info: {
            location: 'San Francisco',
            gravatar_id: '123456789'
          }
        }
      })
    end
  end
end

RSpec.configure do |config|
  config.include Features::AuthenticationHelpers, type: :feature
end
