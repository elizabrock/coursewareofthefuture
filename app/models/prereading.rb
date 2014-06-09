class Prereading < ActiveRecord::Base
	belongs_to :assignment, inverse_of: :prereadings


	validates_presence_of :assignment
end
