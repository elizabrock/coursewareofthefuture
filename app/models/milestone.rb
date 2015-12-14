class Milestone < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :milestones
  has_many :milestone_submissions

  validate :deadline_must_be_appropriate, if: [:assignment, :deadline]
  validates_presence_of :assignment, :instructions, :title
  validates_presence_of :deadline, if: ->{ assignment.try(:published?) }

  default_scope ->{ order("deadline ASC") }

  after_initialize :set_default_corequisite_fullpaths

  def corequisites
    return [] unless corequisite_fullpaths.present?
    corequisite_fullpaths.find_all{|fp| !fp.blank? }.map{ |fp| Corequisite.new(fp) }
  end

  def populate_from_markdown(section, materials)
    return if section.blank?
    lines = section.split("\n")
    return if lines.empty?
    if lines.first.start_with?("#")
      line = lines.delete_at(0)
      self.title = line.gsub(/#+\s*/,"")
    end
    return if lines.empty?
    corequisite_preamble = "> requires: "
    if lines.first.start_with?(corequisite_preamble)
      line = lines.delete_at(0).sub(corequisite_preamble, "")
      line.split(", ").each do |basename|
        filename = basename + ".md"
        material = materials.find_by_filename(filename)
        self.corequisite_fullpaths << material.fullpath if material
      end
    end
    return if lines.empty?
    self.instructions = lines.join("\n").strip
  end

  def publishable?
    deadline.present?
  end

  def title_for_instructor
    student_count = assignment.course.enrollments.count
    submitted_count = milestone_submissions.count
    "#{title} (#{submitted_count} completed, #{student_count - submitted_count} incomplete, due #{deadline})"
  end

  private

  def deadline_must_be_appropriate
    return unless assignment.start_date.present?
    if assignment.start_date > deadline or deadline > assignment.course.end_date.end_of_day
      errors.add(:deadline, "must be in the assignment timeframe of #{assignment.start_date} to #{assignment.course.end_date}")
    end
  end

  def set_default_corequisite_fullpaths
    self.corequisite_fullpaths ||= []
  end
end
