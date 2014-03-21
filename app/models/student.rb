class Student < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable, :omniauth_providers => [:github]

  has_many :self_reports

  validates_format_of :email, with: /\A[^@]+@[^@]+\z/, message: "must be an email address"

  default_scope { order(name: :asc) }

  def self.find_or_create_for_github_oauth(auth)
    where(github_uid: auth.uid).first_or_create do |user|
      user.github_access_token = auth.credentials.token
      user.github_uid = auth.uid
      user.github_username = auth.info.nickname
      user.name = auth.info.name
      user.email = auth.info.email
      user.avatar_url = auth.info.image
    end
  end

  def octoclient
    @octoclient ||= Octokit::Client.new(:access_token => github_access_token)
  end
end
