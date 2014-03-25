class SelfReport < ActiveRecord::Base
  belongs_to :student
  validates_presence_of :student
  validates_presence_of :date
end
