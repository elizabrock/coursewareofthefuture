class Note < ActiveRecord::Base
  validates_presence_of :content

  belongs_to :user
  belongs_to :course



end
