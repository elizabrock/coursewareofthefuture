class Note < ActiveRecord::Base
  validates_presence_of :content

  scope :instructors, ->{ where(instructor: true) }

  belongs_to :user



end
