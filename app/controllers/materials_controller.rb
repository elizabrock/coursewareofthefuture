class MaterialsController < ApplicationController
  expose(:materials){ Material.root(current_student.octoclient) }
  expose(:material){ Material.lookup(params[:id], current_student.octoclient) }
end
