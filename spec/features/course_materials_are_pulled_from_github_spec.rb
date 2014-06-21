require 'rails_helper'

feature "Course materials are pulled from github", vcr: true do
  scenario "Viewing the materials list" do
    course = Fabricate(:course)
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    page.should_not have_exercises_from_github
    hash_of("#all_materials").should == materials_list
  end

  scenario "Viewing the materials list" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    page.should_not have_exercises_from_github
    hash_of("#all_materials").should == remove_links(materials_list)
  end

  scenario "Viewing a single material item" do
    course = Fabricate(:course)
    Fabricate(:covered_material, material_fullpath: "computer-science/logic/logic.md", course: course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    click_link "Logic"
    page.should have_content "Logic is, broadly speaking, the application of reasoning to an activity or concept. In Computer Science, we primarily use deductive reasoning (a.k.a. deductive logic) along with boolean algebra (e.g. two-valued logic)."
    page.should have_css("h1", text: "Logic")
    page.should have_content "Computer Science > Logic"
  end

  scenario "Viewing an image" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    visit root_path
    visit course_path(course) + "/materials/computer-science/logic/wikimedia-commons-venn-and.png"
    filename = "wikimedia-commons-venn-and.png"
    page.response_headers['Content-Type'].should == "image/png"
    page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")

    original_encoded_image = File.read('spec/support/files/wikimedia-commons-venn-and.png', encoding: "ascii-8bit")
    actual_encoded_image = page.body
    actual_encoded_image.should eq(original_encoded_image)
  end

  scenario "Viewing a large image" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    visit root_path
    visit course_path(course) + "/materials/life-skills/data-storage-and-formats.jpg"
    filename = "data-storage-and-formats.jpg"
    page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
    page.response_headers['Content-Type'].should == "image/jpeg"

    original_encoded_image = File.read('spec/support/files/data-storage-and-formats.jpg', encoding: "ascii-8bit")
    actual_encoded_image = page.body
    actual_encoded_image.should eq(original_encoded_image)
  end
end
