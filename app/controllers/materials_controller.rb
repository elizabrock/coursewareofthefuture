class MaterialsController < ApplicationController
  expose(:materials){ Material.materials(current_user.octoclient, current_course.source_repository) }
  expose(:material){ Material.retrieve(params[:id], current_course.source_repository, current_user.octoclient) }

  expose(:read_materials_fullpaths){ current_user.read_materials.map(&:material_fullpath) }

  expose(:covered_materials){ current_course.covered_materials }
  expose(:covered_material){ covered_materials.where(material_fullpath: material.fullpath).first || CoveredMaterial.new(material_fullpath: material.fullpath, covered_on: Time.zone.now) }

  def show
    if material.markdown?
      render :show
    else
      send_data material.content, filename: material.filename, disposition: :inline
    end
  end
end
