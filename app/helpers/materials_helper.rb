module MaterialsHelper

  def covered_material_label_copy(covered_material)
    covered_material.new_record? ? "Upcoming" : "Covered #{covered_material.covered_on}"
  end

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
