class MaterialsController < ApplicationController
  expose(:materials){ Material.root(current_user.octoclient, current_course.source_repository, /^exercises/) }
  expose(:material){ Material.lookup(params[:id], current_course.source_repository, current_user.octoclient) }
  expose(:covered_material_links){ covered_materials.map(&:material_fullpath) }
  expose(:covered_materials){ current_course.covered_materials }

  def show
    if material.is_markdown?
      render :show
    else
      send_data material.content, filename: File.basename(material.fullpath), disposition: :inline
    end
  end
end
