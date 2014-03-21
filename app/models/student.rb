class Student < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  default_scope { order(name: :asc) }
  has_many :self_reports
end
