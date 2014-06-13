module MaterialsHelper
  def pretty_path_for(material)
    material.path.split("/").map{|s| Material.prettify(s)}.join(" > ")
  end

  def edit_material_url(material)
    material.html_url.gsub("blob", "edit") if material.is_markdown?
  end
end
