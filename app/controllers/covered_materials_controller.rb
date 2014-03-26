class CoveredMaterialsController < ApplicationController
  expose(:covered_materials){ current_course.covered_materials }
  expose(:covered_material, attributes: :covered_material_params)

  def create
    covered_material.save!
    redirect_to course_materials_path(current_course), notice: "#{covered_material.material_fullpath} has been marked as covered."
  end

  private

  def covered_material_params
    params.require(:covered_material).permit(:material_fullpath)
  end
end
