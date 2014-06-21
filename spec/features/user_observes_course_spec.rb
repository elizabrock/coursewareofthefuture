require 'rails_helper'

feature "User observes course" do

  scenario "Instructor can make a student an observer" do
    Fabricate(:user, name: "Joe Smith")
    Fabricate(:user, name: "Sally Myers")
    signin_as(:instructor)
    visit root_path
    click_link "View All Students"
    click_link "Sally Myers"
    click_button "Make Observer"
    page.should have_content "Sally Myers is now an observer."
    current_path.should == users_path
    User.where(name: "Sally Myers", observer: true).count.should == 1
    within(".observers") do
      page.should have_content "Sally Myers"
    end
    within(".students") do
      page.should_not have_content "Sally Myers"
    end
  end

  scenario "Instructor can make an instructor an observer" do
    Fabricate(:user, name: "Joe Smith")
    Fabricate(:instructor, name: "Sally Myers")
    signin_as(:instructor)
    visit root_path
    click_link "View All Students"
    within(".instructors") do
      page.should have_content "Sally Myers"
    end
    within(".observers") do
      page.should_not have_content "Sally Myers"
    end
    click_link "Sally Myers"
    click_button "Make Observer"
    within(".observers") do
      page.should have_content "Sally Myers"
    end
    within(".instructors") do
      page.should_not have_content "Sally Myers"
    end
  end

  scenario "Instructor cannot make self an observer" do
    instructor = signin_as(:instructor)
    visit user_path(instructor)
    page.should_not have_button "Make Observer"
  end
end
