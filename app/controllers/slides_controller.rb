require 'slide-em-up/presentation'

class SlidesController < ApplicationController
  expose(:material){ Material.retrieve(params[:material_fullpath], current_course.source_repository, current_user.octoclient) }

  def show
    presentation = SlideEmUp::Presentation.new(contents: material.content, "theme" => "rmcgibbo_slidedeck")
    render text: presentation.html, layout: nil
  end

  def asset
    directory = File.dirname(params[:material_fullpath])
    path = directory + "/" + params[:asset_file] + "." + params[:format]
    material = Material.retrieve(path, current_course.source_repository, current_user.octoclient)
    send_data material.content, filename: material.filename, disposition: :inline
  end
end
