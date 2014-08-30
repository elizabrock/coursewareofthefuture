require 'rails_helper'

describe Material do
  describe ".list", vcr: true do
    let(:user){ Fabricate(:user) }
    let(:materials){ Material.list(user.octoclient, "elizabrock/inquizator-test-repo", "exercises") }
    it "should retrieve all the materials in that subdirectory" do
      expected_materials = [{:title=>"Cheers"}, {:title=>"Ruby Koans"}, {:title=>"Some Other Exercise"}, {:title=>"Unfinished Exercise"}]
      expect(materials.map(&:to_hash)).to eql expected_materials
    end
  end

  describe ".root", vcr: true do
    let(:user){ Fabricate(:user) }
    let(:materials){ Material.root(user.octoclient, "elizabrock/inquizator-test-repo", /^exercises/) }
    it "should load the full material tree" do
      actual_materials = materials.to_hash
      expect(actual_materials).to eql materials_hash
    end
  end
  describe ".retrieve", vcr: true do
    context "with a regular file" do
      let(:user){ Fabricate(:user) }
      let(:material){ Material.retrieve("computer-science/logic/logic.md", "elizabrock/inquizator-test-repo", user.octoclient) }
      it "should include the full material content" do
        filename = Rails.root.join('spec', 'support', 'files', 'logic.md')
        actual_file_content = File.read(filename, encoding: "ascii-8bit")
        expect(material.content).to eql actual_file_content
      end
    end
    context "with a huge file" do
      let(:user){ Fabricate(:user) }
      let(:material){ Material.retrieve("life-skills/data-storage-and-formats.jpg", "elizabrock/inquizator-test-repo", user.octoclient) }
      it "should include the full material content" do
        actual_file_content = File.read('spec/support/files/data-storage-and-formats.jpg', encoding: "ascii-8bit")
        expect(material.content).to eql actual_file_content
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
    describe "#sha" do
      it "should return the shas from the API" do
        expect(markdown_material.sha).to eql "6e590dd772840ca2fc20faf9c764c6737c742a61"
        expect(subdirectory_material.sha).to eql "326b4dd8bb1312a69fbaafba712712a701bb506e"
        expect(image_material.sha).to eql "a67b582e31761e238a7226a521169810d9298f12"
      end
    end
    describe "#directory" do
      it "should return the item's directory" do
        expect(markdown_material.directory).to eql "computer-science/logic"
        expect(subdirectory_material.directory).to eql "computer-science"
        expect(image_material.directory).to eql "computer-science/logic"
      end
    end
    describe "#fullpath" do
      it "should return the item's full path" do
        expect(markdown_material.fullpath).to eql "computer-science/logic/logic.md"
        expect(subdirectory_material.fullpath).to eql "computer-science/logic"
        expect(image_material.fullpath).to eql "computer-science/logic/wikimedia-commons-venn-and.png"
      end
    end
    describe "#filename" do
      it "should return the file/directory name with extension" do
        expect(markdown_material.filename).to eql "logic.md"
        expect(subdirectory_material.filename).to eql "logic"
        expect(image_material.filename).to eql "wikimedia-commons-venn-and.png"
      end
    end
    describe "#formatted_title" do
      it "should return the a humanized name for the file" do
        expect(markdown_material.formatted_title).to eql "Logic"
        expect(subdirectory_material.formatted_title).to eql "Logic"
        expect(image_material.formatted_title).to eql "Wikimedia Commons Venn and.Png"
      end
    end
    describe "#directory?" do
      it "should return false for markdown files" do
        expect(markdown_material.directory?).to be_falsey
      end
      it "should be true for directories" do
        expect(subdirectory_material.directory?).to be_truthy
      end
      it "should be false for non-markdown files" do
        expect(image_material.directory?).to be_falsey
      end
    end
    describe "#markdown?" do
      it "should return true for markdown files" do
        expect(markdown_material.markdown?).to be_truthy
      end
      it "should be false for directories" do
        expect(subdirectory_material.markdown?).to be_falsey
      end
      it "should be false for non-markdown files" do
        expect(image_material.markdown?).to be_falsey
      end
    end
    describe "#html_url" do
      it "should return github url for markdown files" do
        expect(markdown_material.html_url).to eql "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/logic.md"
      end
      it "should return github url for directories" do
        expect(subdirectory_material.html_url).to eql "https://github.com/elizabrock/inquizator-test-repo/tree/master/computer-science/logic"
      end
      it "should return github url for non-markdown files" do
        expect(image_material.html_url).to eql "https://github.com/elizabrock/inquizator-test-repo/blob/master/computer-science/logic/wikimedia-commons-venn-and.png"
      end
    end
    describe "#children" do
      it "should be empty" do
        expect(markdown_material.children).to be_empty
        expect(subdirectory_material.children).to be_empty
        expect(image_material.children).to be_empty
      end
    end
    describe "#content" do
      it "should be nil" do
        expect(markdown_material.content).to be_nil
        expect(subdirectory_material.content).to be_nil
        expect(image_material.content).to be_nil
      end
    end
    describe "#leaf?" do
      it "should be true" do
        expect(markdown_material.leaf?).to eql true
        expect(subdirectory_material.leaf?).to eql true
        expect(image_material.leaf?).to eql true
      end
    end
    describe "#extension" do
      it "should return the extension for blobs" do
        expect(markdown_material.extension).to eql ".md"
        expect(image_material.extension).to eql ".png"
      end
      it "should be blank for directories" do
        expect(subdirectory_material.extension).to eql ""
      end
    end
  end
end
