class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :milestones, inverse_of: :assignment
  has_many :prerequisites, inverse_of: :assignment
  accepts_nested_attributes_for :prerequisites

  validates_presence_of :course

  scope :published, ->{ where(published: true) }

  accepts_nested_attributes_for :milestones

  def first_deadline
    @first_deadline ||= milestones.map(&:deadline).min
  end

  def last_deadline
    @last_deadline ||= milestones.map(&:deadline).max
  end

  def title_with_deadlines
    if first_deadline
      first = first_deadline.strftime("%-m/%d")
      last = last_deadline.strftime("%-m/%d")
      deadlines = (first == last) ? first : [first, last].join(" - ")
      "#{title} (#{deadlines})"
    else
      title
    end
  end

  def populate_from_github(path, client)
    markdown = Material.lookup(path + "/instructions.md", course.source_repository, client).content
    sections = markdown.split("##").each do |section|
      title, body = section.split("\n",2)
      title.gsub!(/#+\s*/,"")
      if summary.blank?
        self.title = title
        self.summary = body
      else
        self.milestones.build(title: title, instructions: body)
      end
    end
  end
end
