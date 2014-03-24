class MaterialsController < ApplicationController
  expose(:materials){ Material.root(current_user.octoclient) }
  expose(:material){ Material.lookup(params[:id], current_user.octoclient) }
end
