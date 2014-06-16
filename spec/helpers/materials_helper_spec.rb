require 'rails_helper'

describe MaterialsHelper do
  let(:markdown_tree_item) {
    double(:sawyer_resource,
          path: "computer-science/logic/logic.md",
          html_url: "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/logic.md") }

  let(:subdirectory_tree_item) {
    double(:sawyer_resource,
          path: "computer-science/logic",
          html_url: "https://github.com/elizabrock/inquizator-test-repo/tree/master/computer-science/logic") }

  let(:image_tree_item) {
    double(:sawyer_resource,
          path: "computer-science/logic/wikimedia-commons-venn-and.png",
          html_url: "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/wikimedia-commons-venn-and.png" ) }

  let(:markdown_material){ Material.new(markdown_tree_item) }
  let(:subdirectory_material){ Material.new(subdirectory_tree_item) }
  let(:image_material){ Material.new(image_tree_item) }

  describe "#edit_material_url" do
    it "should return github edit url for markdown files" do
      edit_material_url(markdown_material).should == "https://github.com/elizabrock/inquizator-test-repo/edit/master/computer-science/logic/logic.md"
    end
    it "should be nil for directories" do
      edit_material_url(subdirectory_material).should be_nil
    end
    it "should be nil for non-markdown files" do
      edit_material_url(image_material).should be_nil
    end
  end

  describe "#pretty_path_for" do
    it "should return the a humanized name for a file's directory" do
      pretty_path_for(markdown_material).should == "Computer Science > Logic > "
    end
    it "should return the a humanized name for a directory's parent directory" do
      pretty_path_for(subdirectory_material).should == "Computer Science > "
    end
    it "should return the a humanized name for an image's directory" do
      pretty_path_for(image_material).should == "Computer Science > Logic > "
    end
  end
end
