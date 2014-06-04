module Features
  module AuthenticationHelpers

    def signin_as(user_type, options = {})
      user = (user_type.is_a? Symbol) ? Fabricate(user_type, options) : user_type
      sign_into_github_as(user.github_username, uid: user.github_uid)
      visit user_omniauth_authorize_path("github")
      if user.instructor?
        visit course_path(user.courses.first) unless user.courses.empty?
      end
      user
    end

    def sign_into_github_as(username, uid: nil, token: "702be0ced015bd4102a65ae6aa79ecfe296a2711")
      if uid.nil?
        user = User.find_by_github_username(username)
        uid = user.try(:github_uid) || '12345'
      end

      photo_url = "https://avatars.github.com/#{uid}?s=460"
      @default_image ||= File.read(Rails.root.join('spec', 'support', 'files', 'arson_girl.jpg'))
      stub_request(:get, photo_url).to_return( body: @default_image, :status   => 200, :headers  => { 'Content-Type' => "image/jpeg; charset=UTF-8" } )

      OmniAuth.config.add_mock(:github, {
        uid: uid,
        credentials: {
          token: token
        },
        info: {
          nickname: username,
          email: "#{username}smith@example.com",
          name: "#{username.capitalize} Smith",
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
