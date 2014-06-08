class Prereading < ActiveRecord::Base
	belongs_to :assignment


	validates_presence_of :assignment
end
