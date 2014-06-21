class MaterialsController < ApplicationController

  expose(:materials){ Material.root(current_user.octoclient, current_course.source_repository, /^exercises/) }
  expose(:material){ Material.retrieve(params[:id], current_course.source_repository, current_user.octoclient) }

  expose(:read_materials_fullpaths){ current_user.read_materials.map(&:material_fullpath) }

  expose(:covered_materials){ current_course.covered_materials }
  expose(:covered_material){ covered_materials.where(material_fullpath: material.link).first }

  def show
    if material.markdown?
      render :show
    else
      send_data material.content, filename: material.filename, disposition: :inline
    end
  end
end
