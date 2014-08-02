require 'rails_helper'

feature "Student enrolls in course" do

  let!(:cohort4a){ Fabricate(:course, title: "Cohort 4a") }
  let!(:cohort4b){ Fabricate(:course, title: "Cohort 4b") }
  let!(:cohort1a){ Fabricate(:past_course, title: "Cohort 1a") }
  let!(:cohort1b){ Fabricate(:past_course, title: "Cohort 1b") }

  scenario "Fix: Instructors are automatically enrolled in courses" do
    signin_as(:instructor)
    visit root_path
    page.should have_content "Which course are you teaching today?"
    click_link "Cohort 4a"
    current_path.should == course_path(cohort4a)
    click_link "Inquizator"
    click_link "Cohort 4a"
    current_path.should == course_path(cohort4a)
    click_link "Inquizator"
    click_link "Cohort 4b"
    current_path.should == course_path(cohort4b)
  end

  scenario "Student enrolling in a course" do
    signin_as :student
    visit root_path
    page.should have_content "Please select a course below to join it"
    page.should have_button("Join Cohort 4a")
    page.should have_button("Join Cohort 4b")
    page.should_not have_button("Join Cohort 1a")
    page.should_not have_button("Join Cohort 1b")
    click_button "Join Cohort 4a"
    page.should have_content "You are now enrolled in Cohort 4a"
    current_path.should == course_path(cohort4a)
  end

  scenario "Student signing in or going to the homepage takes you to your course" do
    cohort3 = Fabricate(:course, title: "Cohort 3")
    signin_as :student, courses: [cohort3]
    visit root_path
    current_path.should == course_path(cohort3)
  end

  scenario "Student signing up for a second course" do
    cohort3 = Fabricate(:course, title: "Cohort 3")
    signin_as :student, courses: [cohort3]
    visit root_path
    current_path.should == course_path(cohort3)
    click_link "Enroll in another course"
    page.should have_button("Join Cohort 4a")
    page.should have_button("Join Cohort 4b")
    page.should_not have_button("Join Cohort 1a")
    page.should_not have_button("Join Cohort 1b")
    page.should_not have_button("Join Cohort 3")
    click_button "Join Cohort 4a"
    page.should have_content "You are now enrolled in Cohort 4a"
    current_path.should == course_path(cohort4a)
  end

  scenario "Signing up for a second course makes it your default course" do
    cohort3 = Fabricate(:course, title: "Cohort 3")
    signin_as :student, courses: [cohort3]
    visit root_path
    current_path.should == course_path(cohort3)
    click_link "Enroll in another course"
    click_button "Join Cohort 4b"
    page.should have_content "You are now enrolled in Cohort 4b"
    current_path.should == course_path(cohort4b)
    visit root_path
    current_path.should == course_path(cohort4b)
  end

  scenario "Enroll in another course doesn't show up if there are no courses" do
    Course.destroy_all
    signin_as :student
    visit new_enrollment_path
    page.should_not have_content("Please select a course")
    page.should have_content("There are no open courses at this time.")
  end

  scenario "If there are no courses, enrollment page shows appropriate message" do
    Course.destroy_all
    signin_as :student
    visit root_path
    page.should_not have_link "Enroll in another course"
  end

  scenario "Enroll in another course doesn't show up if you're enrolled in all courses" do
    signin_as :student, courses: [cohort4a, cohort4b]
    visit root_path
    page.should_not have_link "Enroll in another course"
  end

  scenario "Enrollments view shows all students enrolled in course." do
    course = Fabricate(:course)
    Fabricate(:instructor)
    Fabricate(:student, name: "Pookie", photo: File.new('spec/support/files/pookie.jpg'), courses: [course])
    Fabricate(:student, name: "Bea", photo: File.new('spec/support/files/bea.jpg'), courses: [course])
    bert = Fabricate(:student, name: "Bert", photo: File.new('spec/support/files/arson_girl.jpg'), courses: [course])
    signin_as bert
    click_link "Peers"

    expected_list = [ { name: "Bea", image: "bea.jpg" },
                      { name: "Bert", image: "arson_girl.jpg" },
                      { name: "Pookie", image: "pookie.jpg" }]
    expected_list.each_with_index do |content, row|
      text = content[:name]
      image_path = content[:image]
      page.should have_xpath("//ul/li[#{row+1}][contains(normalize-space(.), '#{text}')]//img[contains(@src, '#{image_path}')]")
    end
  end
end
