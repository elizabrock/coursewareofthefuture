class AddSourceRepositoryToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :source_repository, :string
  end
end
