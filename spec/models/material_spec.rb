require 'rails_helper'

describe Material do

  describe ".list", vcr: true do
    let(:user){ Fabricate(:user) }
    let(:materials){ Material.list(user.octoclient, "elizabrock/inquizator-test-repo", "exercises") }
    it "should retrieve all the materials in that subdirectory" do
      expected_materials = [{:title=>"Cheers"}, {:title=>"Ruby Koans"}, {:title=>"Some Other Exercise"}, {:title=>"Unfinished Exercise"}]
      materials.map(&:to_hash).should == expected_materials
    end
  end

  describe ".root", vcr: true do
    let(:user){ Fabricate(:user) }
    let(:materials){ Material.root(user.octoclient, "elizabrock/inquizator-test-repo", /^exercises/) }
    it "should load the full material tree" do
      actual_materials = materials.to_hash
      actual_materials.should == materials_hash
    end
  end
  describe ".retrieve", vcr: true do
    context "with a regular file" do
      let(:user){ Fabricate(:user) }
      let(:material){ Material.retrieve("computer-science/logic/logic.md", "elizabrock/inquizator-test-repo", user.octoclient) }
      it "should include the full material content" do
        filename = Rails.root.join('spec', 'support', 'files', 'logic.md')
        actual_file_content = File.read(filename, encoding: "ascii-8bit")
        material.content.should == actual_file_content
      end
    end
    context "with a huge file" do
      let(:user){ Fabricate(:user) }
      let(:material){ Material.retrieve("life-skills/data-storage-and-formats.jpg", "elizabrock/inquizator-test-repo", user.octoclient) }
      it "should include the full material content" do
        actual_file_content = File.read('spec/support/files/data-storage-and-formats.jpg', encoding: "ascii-8bit")
        material.content.should == actual_file_content
      end
    end
  end
  describe "individual materials" do
    let(:markdown_tree_item) {
      double(:sawyer_resource,
            content: nil,
            mode: "100644",
            type: "blob",
            sha: "6e590dd772840ca2fc20faf9c764c6737c742a61",
            path: "computer-science/logic/logic.md",
            size: 3910,
            html_url: "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/logic.md") }

    let(:subdirectory_tree_item) {
      double(:sawyer_resource,
            content: nil,
            mode: "040000",
            type: "tree",
            sha: "326b4dd8bb1312a69fbaafba712712a701bb506e",
            path: "computer-science/logic",
            html_url: "https://github.com/elizabrock/inquizator-test-repo/tree/master/computer-science/logic") }

    let(:image_tree_item) {
      double(:sawyer_resource,
            content: nil,
            mode: "100644",
            type: "blob",
            sha: "a67b582e31761e238a7226a521169810d9298f12",
            path: "computer-science/logic/wikimedia-commons-venn-and.png",
            size: 7369,
            html_url: "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/wikimedia-commons-venn-and.png" ) }
    let(:markdown_material){ Material.new(markdown_tree_item) }
    let(:subdirectory_material){ Material.new(subdirectory_tree_item) }
    let(:image_material){ Material.new(image_tree_item) }
    # FIXME: Allow for this functionality:
    # let(:local_material){ Material.new("computer-science/logic/logic.md") }
    describe "#sha" do
      it "should return the shas from the API" do
        markdown_material.sha.should == "6e590dd772840ca2fc20faf9c764c6737c742a61"
        subdirectory_material.sha.should == "326b4dd8bb1312a69fbaafba712712a701bb506e"
        image_material.sha.should == "a67b582e31761e238a7226a521169810d9298f12"
      end
    end
    describe "#path" do
      it "should return the item's directory" do
        markdown_material.path.should == "computer-science/logic"
        subdirectory_material.path.should == "computer-science"
        image_material.path.should == "computer-science/logic"
      end
    end
    describe "#fullpath" do
      it "should return the item's full path" do
        markdown_material.fullpath.should == "computer-science/logic/logic.md"
        subdirectory_material.fullpath.should == "computer-science/logic"
        image_material.fullpath.should == "computer-science/logic/wikimedia-commons-venn-and.png"
      end
    end
    describe "#filename" do
      it "should return the file/directory name with extension" do
        markdown_material.filename.should == "logic.md"
        subdirectory_material.filename.should == "logic"
        image_material.filename.should == "wikimedia-commons-venn-and.png"
      end
    end
    describe "#pretty_name" do
      it "should return the a humanized name for the file" do
        markdown_material.pretty_name.should == "Logic"
        subdirectory_material.pretty_name.should == "Logic"
        image_material.pretty_name.should == "Wikimedia Commons Venn and.Png"
      end
    end
    describe "#directory?" do
      it "should return false for markdown files" do
        markdown_material.directory?.should be_falsey
      end
      it "should be true for directories" do
        subdirectory_material.directory?.should be_truthy
      end
      it "should be false for non-markdown files" do
        image_material.directory?.should be_falsey
      end
    end
    describe "#is_markdown?" do
      it "should return true for markdown files" do
        markdown_material.is_markdown?.should be_truthy
      end
      it "should be false for directories" do
        subdirectory_material.is_markdown?.should be_falsey
      end
      it "should be false for non-markdown files" do
        image_material.is_markdown?.should be_falsey
      end
    end
    describe "#link" do
      it "should return link for markdown files" do
        markdown_material.link.should == "materials/computer-science/logic/logic.md"
      end
      it "should be nil for directories" do
        subdirectory_material.link.should be_nil
      end
      it "should be nil for non-markdown files" do
        image_material.link.should be_nil
      end
    end
    describe "#html_url" do
      it "should return github url for markdown files" do
        markdown_material.html_url.should == "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/logic.md"
      end
      it "should return github url for directories" do
        subdirectory_material.html_url.should == "https://github.com/elizabrock/inquizator-test-repo/tree/master/computer-science/logic"
      end
      it "should return github url for non-markdown files" do
        image_material.html_url.should == "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/wikimedia-commons-venn-and.png"
      end
    end
    describe "#children" do
      it "should be empty" do
        markdown_material.children.should be_empty
        subdirectory_material.children.should be_empty
        image_material.children.should be_empty
      end
    end
    describe "#content" do
      it "should be nil" do
        markdown_material.content.should be_nil
        subdirectory_material.content.should be_nil
        image_material.content.should be_nil
      end
    end
    describe "#is_leaf?" do
      it "should be true" do
        markdown_material.is_leaf?.should == true
        subdirectory_material.is_leaf?.should == true
        image_material.is_leaf?.should == true
      end
    end
    describe "#extension" do
      it "should return the extension for blobs" do
        markdown_material.extension.should == ".md"
        image_material.extension.should == ".png"
      end
      it "should be blank for directories" do
        subdirectory_material.extension.should == ""
      end
    end
  end
end
