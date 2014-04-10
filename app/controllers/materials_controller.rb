class MaterialsController < ApplicationController
  expose(:materials){ Material.root(current_user.octoclient, current_course.source_repository, /^exercises/) }
  expose(:material){ Material.lookup(params[:id], current_course.source_repository, current_user.octoclient) }
  expose(:covered_material_links){ current_course.covered_materials.pluck(:material_fullpath) }

  def show
    if material.is_markdown?
      render :show
    else
      send_data material.content, filename: File.basename(material.fullpath), disposition: :inline
    end
  end
end
