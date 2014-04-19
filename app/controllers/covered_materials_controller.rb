require 'slide-em-up/presentation'

class CoveredMaterialsController < ApplicationController
  expose(:covered_materials){ current_course.covered_materials }
  expose(:covered_material, attributes: :covered_material_params)

  before_filter :require_instructor!

  def slides
    presentation = SlideEmUp::Presentation.new(contents: covered_material.material(current_user.octoclient).content, "theme" => "rmcgibbo_slidedeck")
    render text: presentation.html, layout: nil
  end

  def asset
    path = File.dirname(covered_material.fullpath) + "/" + params[:asset_file] + "." + params[:format]
    material = Material.lookup(path, current_course.source_repository, current_user.octoclient)
    send_data material.content, filename: material.filename, disposition: :inline
  end

  def create
    covered_material.save!
    redirect_to course_materials_path(current_course), notice: "#{covered_material.material_fullpath} has been marked as covered on #{covered_material.covered_on.strftime('%Y/%m/%d')}."
  end
  alias update create

  private

  def covered_material_params
    params.require(:covered_material).permit(:material_fullpath, :covered_on)
  end
end
