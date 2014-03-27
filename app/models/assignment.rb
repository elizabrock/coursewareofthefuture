class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :milestones, inverse_of: :assignment

  scope :published, ->{ where(published: true) }

  accepts_nested_attributes_for :milestones

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
