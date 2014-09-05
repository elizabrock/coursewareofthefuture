require 'rails_helper'

feature "View student list" do

  scenario "Link to student list visible on home page" do
    visit root_path
    expect(page).to have_content("View Student List")
  end

  scenario "Viewing the student list" do
    Fabricate(:student, name: "Will Smith")
    Fabricate(:student, name: "Beyonce Knowles")
    Fabricate(:student, name: "Bill Cosby")
    visit root_path
    click_link "View Student List"
    expect(current_path).to eq students_path
    expect(page).to have_content("Will Smith")
    expect(page).to have_content("Beyonce Knowles")
    expect(page).to have_content("Bill Cosby")
    find(".profile_photo")[:src].should include("arson_girl")
  end
end
