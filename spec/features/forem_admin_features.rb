require 'spec_helper'

feature "Forem admin creates forum categories" do

  scenario "Viewing forem admin area as forem admin" do
    signin_as :forem_admin
    visit root_path
    click_link "Forum Admin"
    page.should have_content "Admin Area"
    page.should have_content "Welcome to forem's Admin Area."
    page.should have_link "Manage Forums"
    page.should have_link "Manage Forum Categories"
    page.should have_link "Manage Groups"
    page.should have_link "Back to forums"
  end

  scenario "viewing forem admin area as non forem admin" do
    signin_as :user
    visit root_path
    page.should_not have_link "Forum Admin"
    visit forem.admin_root_path
    page.should_not have_content "Admin Area"
    page.should_not have_content "Welcome to forem's Admin Area."
    page.should_not have_link "Manage Forums"
    page.should_not have_link "Manage Forum Categories"
    page.should_not have_link "Manage Groups"
    page.should_not have_link "Back to forums"
  end

  scenario "forem admin creates forum category" do
    signin_as :forem_admin
    visit forem.admin_root_path
    click_link "Manage Forum Categories"
    page.should have_link "Back to Admin"
    page.should have_link "New Forum Category"
    page.should have_link "Manage Forums"
    click_link "New Forum Category"
    page.should have_content "Creating a new Forum Category"
    fill_in "Name", with: "Test Category"
    click_button "Create Category"
    page.should have_content "This forum category has been created."
    page.should have_link "Edit"
    page.should have_link "Delete"
    page.should have_content "Test Category"
    click_link "Edit"
    page.should have_content "Editing the Test Category category"
    fill_in "Name", with: "Test"
    click_button "Update Category"
    page.should have_content "That forum category has been updated."
    page.should have_link "Edit"
    page.should have_link "Delete"
    page.should_not have_content "Test Category"
    page.should have_content "Test"
    click_link "Delete"
    page.should have_content "The selected forum category has been deleted."
    page.should_not have_link "Edit"
    page.should_not have_link "Delete"
    page.should_not have_content "Test Category"
    page.should_not have_content "Test"
  end

  scenario "forem admin creates a new forum" do
    signin_as :forem_admin
    visit forem.admin_root_path
    click_link "Manage Forum Categories"
    click_link "New Forum Category"
    fill_in "Name", with: "Test"
    click_button "Create Category"
    visit forem.admin_root_path
    click_link "Manage Forums"
    page.should have_link "Back to Admin"
    page.should have_link "New Forum"
    click_link "New Forum"
    page.should have_content "Creating a new forum"
    page.should have_content "Category"
    page.should have_content "Title"
    page.should have_content "Description"
    page.should have_content "Moderator groups"
    page.should have_content "Moderators"
    page.should have_button "Create Forum"
    select("Test", :from => "Category")
    fill_in "Title", with: "Test-Title"
    fill_in "Description", with: "Test-Description"
    click_button "Create Forum"
    page.should have_content "This forum has been created."
    page.should have_content "Test"
    page.should have_link "Edit"
    page.should have_link "Delete"
    page.should have_link "Test-Title"
    page.should have_content "Test-Description"
    page.should have_content "Last post None"
    page.should have_content "Moderators: None"
    click_link "Edit"
    fill_in "Title", with: "New Title"
    click_button "Update Forum"
    page.should have_link "New Title"
    page.should_not have_link "Test-Title"
    click_link "New Title"
    page.should have_link "Forums"
    page.should have_link "Test"
    page.should have_link "New Title"
    page.should have_content "Test-Description"
    page.should have_link "New topic"
    page.should have_link "Moderation Tools"
    page.should have_content "There are no topics in this forum currently."
    visit forem.admin_root_path
    click_link "Manage Forums"
    click_link "Delete"
    page.should have_content "The selected forum has been deleted."
    page.should_not have_content "Test"
    page.should_not have_link "Edit"
    page.should_not have_link "Delete"
    page.should_not have_link "Test-Title"
    page.should_not have_content "Test-Description"
    page.should_not have_content "Last post None"
    page.should_not have_content "Moderators: None"
  end

  scenario "Admin works with groups" do
    signin_as :forem_admin
    visit forem.admin_root_path
    click_link "Manage Groups"
    page.should have_content "Manage Groups"
    page.should have_link "Back to Admin"
    page.should have_link "New Group"
    click_link "New Group"
    page.should have_content "New Group"
    page.should have_content "Name"
    fill_in "Name", with: "Test Group"
    click_button "Create Group"
    page.should have_content "The group was successfully created."
    page.should have_content "Members in Test Group"
    page.should have_link "Back to groups"
    page.should have_content "Add a new member"
    fill_in "user_id", with: '1'
  end

  scenario "User adds new topic" do
    signin_as :forem_admin
    visit forem.admin_root_path
    click_link "Manage Forum Categories"
    click_link "New Forum Category"
    fill_in "Name", with: "Test"
    click_button "Create Category"
    click_link "Back to Admin"
    click_link "Manage Forums"
    click_link "New Forum"
    select("Test", :from => "Category")
    fill_in "Title", with: "Test-Title"
    fill_in "Description", with: "Test-Description"
    click_button "Create Forum"
    click_link "Back to Admin"
    click_link "Back to forums"
    page.should have_content "Forums"
    page.should have_link "Test"
    page.should have_link "Test-Title"
    click_link "Test-Title"
    page.should have_link "New topic"
    page.should have_content "There are no topics in this forum currently."
    click_link "New topic"
    page.should have_link "Forums"
    page.should have_link "Test"
    page.should have_link "Back to topics"
    page.should have_content "Subject"
    page.should have_content "Text"
    page.should have_button "Create Topic"
    fill_in "Subject", with: "Super Cool Subject"
    fill_in "Text", with: "Some super cool text"
    click_button "Create Topic"
    page.should have_link "Forums"
    page.should have_link "Test-Title"
    page.should have_content "Super Cool Subject"
    page.should have_link "Reply"
    page.should have_link "Delete"
    page.should have_link "Unsubscribe"
    page.should have_link "Edit topic"
    page.should have_link "Hide this topic"
    page.should have_link "Lock this topic"
    page.should have_link "Pin this topic"
    page.should have_link "Quote"
    click_link "Reply"
    page.should have_content "Text"
    page.should have_button "Post Reply"
    fill_in "Text", with: "Cool Reply"
    click_button "Post Reply"
    page.should have_content "Your reply has been posted."
    page.should have_content "Cool Reply"
    click_link "Delete"
    page.should have_content "There are no topics in this forum currently."
  end
end
