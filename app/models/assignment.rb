class Assignment < ActiveRecord::Base
  attr_accessor :source

  belongs_to :course
  has_many :milestones, inverse_of: :assignment

  accepts_nested_attributes_for :milestones

  validate :start_date_must_be_appropriate, if: [:course, :start_date]
  validates_presence_of :course
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

  private

  def start_date_must_be_appropriate
    if course.start_date > start_date or start_date > course.end_date.end_of_day
      errors.add(:start_date, "must be in the course timeframe of #{course.start_date} to #{course.end_date}")
    end
  end
end
