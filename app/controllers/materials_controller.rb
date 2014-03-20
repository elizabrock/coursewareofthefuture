class MaterialsController < ApplicationController
  expose(:materials){ Material.root(current_student.octoclient) }
end
