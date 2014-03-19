class MaterialsController < ApplicationController
  expose(:materials){ process_tree(Octokit.tree(ENV["MATERIALS_REPO"], "master", recursive: true).tree) }

  protected

  def process_tree(tree)
    ancestor_material = Material.new()
    tree.each do |item|
      path = item.path
      populate_path_into(item, path, ancestor_material)
    end
    ancestor_material
  end

  def populate_path_into(item, path, ancestor_material)
    subdirectory_or_file, remaining_path = path.split("/", 2)
    if remaining_path.blank? # Because we are now in this item's parent directory
      ancestor_material.add_child( item )
    else
      closer_ancestor = ancestor_material.find_child(subdirectory_or_file)
      populate_path_into(item, remaining_path, closer_ancestor)
    end
  end
end
