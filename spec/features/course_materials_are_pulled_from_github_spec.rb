require 'spec_helper'

feature "Course materials are pulled from github", vcr: true do
  scenario "Viewing the materials list" do
    course = Fabricate(:course)
    signin_as :instructor, courses: [course]
    visit course_path(course)
    click_link "Materials"
    page.should_not have_exercise_from_github
    page.should have_materials_tree("inquizator-test-repo", links: false)
  end

  scenario "Viewing the materials list" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    page.should_not have_exercise_from_github
    page.should have_materials_tree("inquizator-test-repo", links: true)
  end

  scenario "Viewing a single material item" do
    course = Fabricate(:course)
    Fabricate(:covered_material, material_fullpath: "materials/computer-science/logic/logic.md", course: course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Materials"
    click_link "Logic"
    page.should have_content "Logic is, broadly speaking, the application of reasoning to an activity or concept. In Computer Science, we primarily use deductive reasoning (a.k.a. deductive logic) along with boolean algebra (e.g. two-valued logic)."
    page.should have_css("h1", text: "Logic")
  end

  scenario "Viewing an image" do
    course = Fabricate(:course)
    signin_as :student, courses: [course]
    visit root_path
    visit course_path(course) + "/materials/computer-science/logic/wikimedia-commons-venn-and.png"
    filename = "wikimedia-commons-venn-and.png"
    page.response_headers['Content-Type'].should == "image/png"
    page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
  end
end
