class Assignment < ActiveRecord::Base
  attr_accessor :source

  belongs_to :course
  has_many :milestones, inverse_of: :assignment

  accepts_nested_attributes_for :milestones

  validate :start_date_must_be_appropriate, if: [:course, :start_date]
  validates_presence_of :course, :title
  validates_presence_of :start_date, if: Proc.new{ |a| a.published? }
  validates_associated :milestones
  validates_length_of :milestones, minimum: 1, message: "must contain at least one milestone", if: Proc.new{ |a| a.published? }

  scope :published, ->{ where(published: true) }

  def end_date
    milestones.last.try(:deadline) || course.end_date
  end

  def publishable?
    start_date.present? && !milestones.empty? && milestones.all?{ |m| m.publishable? }
  end

  def title_with_deadlines
    if start_date
      deadlines = (start_date == end_date) ? start_date : [start_date, end_date].join(" - ")
      "#{title} (#{deadlines})"
    else
      title
    end
  end

  def populate_from_github(client)
    markdown = Material.retrieve(source, course.source_repository, client).content
    materials = Material.materials(client, course.source_repository)

    sections = markdown.split("##")
    if sections.first.match(/^#[^#]/)
      title_section = sections.delete_at(0)
      title, summary = title_section.split("\n",2)
      self.title = title.gsub(/#\s*/,"")
      self.summary = summary.strip
    elsif !sections.first.match(/^##/) # This isn't a milestone, either..
      self.summary = sections.delete_at(0).strip
    end

    sections.each do |section|
      full_section = "##" + section
      self.milestones.build.populate_from_markdown(full_section, materials)
    end
  end

  private

  def start_date_must_be_appropriate
    if course.start_date > start_date or start_date > course.end_date.end_of_day
      errors.add(:start_date, "must be in the course timeframe of #{course.start_date} to #{course.end_date}")
    end
  end
end
