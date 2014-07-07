module MaterialsHelper

  def material_path_for(material)
    course_material_path(current_course, material.fullpath).gsub("%2F", "/")
  end

  def pretty_path_for(material)
    material.directory.split("/").map{|s| Material.prettify(s)}.join(" > ") + " > "
  end

  def edit_material_url(material)
    material.html_url.gsub("blob", "edit") if material.markdown?
  end
end
