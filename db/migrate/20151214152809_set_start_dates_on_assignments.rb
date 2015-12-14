class MyAssignment < ActiveRecord::Base
  self.table_name = :assignments
  has_many :milestones, foreign_key: :assignment_id, class_name: "MyMilestone"
end
class MyMilestone < ActiveRecord::Base
  self.table_name = :milestones
  default_scope ->{ order("deadline ASC") }
  belongs_to :assignment, class_name: "MyAssignment"
end

class SetStartDatesOnAssignments < ActiveRecord::Migration
  def up
    MyAssignment.all.each do |assignment|
      assignment.update_attribute(:start_date, assignment.milestones.first.try(:deadline))
    end
  end

  def down
    MyAssignment.all.each do |assignment|
      assignment.update_attribute(:start_date, nil)
    end
  end
end
