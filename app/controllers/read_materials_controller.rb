class ReadMaterialsController < ApplicationController
  expose(:read_materials){ current_user.read_materials }
  expose(:read_material, attributes: :read_material_params)

  def create
    read_material.save!
    flash[:notice] = "#{read_material.formatted_title} has been marked as read."
    redirect_to course_materials_path(current_course)
  end

  private

  def read_material_params
    params.require(:read_material).permit(:material_fullpath)
  end
end
