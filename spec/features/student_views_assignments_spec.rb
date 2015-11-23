require 'rails_helper'

feature "Student views assignments" do
  scenario "Student views an assignment", vcr: true do
    course = Fabricate(:course,
      title: "Cohort 4",
      start_date: "2013/04/28",
      end_date: "2013/06/01")
    signin_as :student, courses: [course], github_username: "elizabrock"
    assignment = Fabricate(:assignment, title: "Capstone", course: course)
    Fabricate(:milestone, title: "Milestone 1", deadline: "2013/05/01", instructions: "This milestone is simple", assignment: assignment)
    Fabricate(:milestone, title: "Milestone 2", deadline: "2013/05/15", instructions: "This milestone is hard", assignment: assignment)
    visit root_path
    click_link "Assignments"
    click_link "Capstone"
    page.should have_content("Milestone 1 (due 5/01)")
    page.should have_content("Milestone 2 (due 5/15)")
    within(milestone(1)){ page.should have_content "This milestone is simple" }
    within(milestone(2)){ page.should have_content "Ability to view and submit this milestone is pending completion of previous milestones" }
  end

  scenario "Student views an assignment with corequisites", vcr: true do
    course = Fabricate(:course,
      title: "Cohort 4",
      start_date: "2013/04/28",
      end_date: "2013/06/01")
    student = signin_as :student, courses: [course], github_username: "elizabrock"

    assignment = Fabricate(:assignment, title: "Capstone", course: course)

    milestone_foo = Fabricate(:milestone,
              title: "Foo",
              deadline: "2013/05/15",
              corequisite_fullpaths: ["computer-science/logic/logic.md"],
              assignment: assignment)
    Fabricate(:milestone,
              title: "Bar",
              deadline: "2013/05/28",
              corequisite_fullpaths: ["computer-science/programming/advanced-programming/garbage-collection.md"],
              assignment: assignment)

    visit course_assignment_path(course, assignment)

    within(milestone("Foo")) do
      page.should have_content("Logic")
      page.should_not have_content("Booleans and Bits")
      page.should_not have_content("Garbage Collection")
    end
    Fabricate(:milestone_submission, user: student, milestone: milestone_foo)
    visit course_assignment_path(course, assignment)
    within(milestone("Bar")) do
      page.should have_content("Garbage Collection")
      page.should_not have_content("Logic")
      page.should_not have_content("Booleans and Bits")
    end

    click_link "Logic"
    current_path.should == "/courses/#{course.id}/materials/computer-science/logic/logic.md"
    page.should have_content "Logic is, broadly speaking, the application of reasoning to an activity or concept. In Computer Science, we primarily use deductive reasoning (a.k.a. deductive logic) along with boolean algebra (e.g. two-valued logic)."
  end

  scenario "Viewing the assignment list only shows published assignments" do
    course = Fabricate(:course, title: "Cohort 4")
    Fabricate(:assignment, title: "Foobar", published: false, course: course)
    Fabricate(:assignment, title: "Capstone", published: true, course: course)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Assignments"
    page.should have_content "Capstone"
    page.should_not have_content "Foobar"
  end

  scenario "Viewing the assignment list shows the deadlines" do
    course = Fabricate(:course,
        title: "Cohort 4",
        start_date: "2013/05/01",
        end_date: "2014/05/01")
    assignment = Fabricate(:published_assignment, title: "Foobar", course: course)
    Fabricate(:milestone, title: "Milestone 1", deadline: "2013/05/01", assignment: assignment)
    Fabricate(:milestone, title: "Milestone 2", deadline: "2013/05/15", assignment: assignment)
    signin_as :student, courses: [course]
    visit root_path
    click_link "Assignments"
    page.should have_content "Foobar (5/01 - 5/15)"
  end

  scenario "Viewing the assignment list prints them in deadline order" do
    course = Fabricate(:course,
              title: "Cohort 4",
              start_date: "2012/03/01",
              end_date: "2015/03/01")
    assignment = Fabricate(:published_assignment, title: "Foobar", course: course)
    Fabricate(:milestone,
              title: "Milestone 1",
              deadline: "2013/05/01",
              assignment: assignment)
    Fabricate(:milestone,
              title: "Milestone 2",
              deadline: "2013/05/15",
              assignment: assignment)

    assignment = Fabricate(:published_assignment, title: "Final", course: course)
    Fabricate(:milestone,
              title: "Milestone 1",
              deadline: "2013/06/01",
              assignment: assignment)

    assignment = Fabricate(:published_assignment, title: "Things", course: course)
    Fabricate(:milestone,
              title: "Milestone 1",
              deadline: "2013/05/14",
              assignment: assignment)
    Fabricate(:milestone,
              title: "Milestone 2",
              deadline: "2013/05/31",
              assignment: assignment)

    assignment = Fabricate(:assignment, title: "BazGrille", course: course)
    Fabricate(:milestone,
              title: "Milestone 1",
              deadline: "2013/04/01",
              instructions: "This milestone is simple",
              assignment: assignment)

    signin_as :student, courses: [course]
    visit root_path
    click_link "Assignments"
    page.should have_list ["BazGrille (4/01)", "Foobar (5/01 - 5/15)", "Things (5/14 - 5/31)", "Final (6/01)"]
  end
end
