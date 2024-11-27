require "application_system_test_case"

class RailsTest < ApplicationSystemTestCase
  setup do
    @rail = rails(:one)
  end

  test "visiting the index" do
    visit rails_url
    assert_selector "h1", text: "Rails"
  end

  test "should create rail" do
    visit rails_url
    click_on "New rail"

    fill_in "Category", with: @rail.Category
    fill_in "Description", with: @rail.description
    fill_in "Generate", with: @rail.generate
    fill_in "Name", with: @rail.name
    fill_in "Scaffold", with: @rail.scaffold
    click_on "Create Rail"

    assert_text "Rail was successfully created"
    click_on "Back"
  end

  test "should update Rail" do
    visit rail_url(@rail)
    click_on "Edit this rail", match: :first

    fill_in "Category", with: @rail.Category
    fill_in "Description", with: @rail.description
    fill_in "Generate", with: @rail.generate
    fill_in "Name", with: @rail.name
    fill_in "Scaffold", with: @rail.scaffold
    click_on "Update Rail"

    assert_text "Rail was successfully updated"
    click_on "Back"
  end

  test "should destroy Rail" do
    visit rail_url(@rail)
    click_on "Destroy this rail", match: :first

    assert_text "Rail was successfully destroyed"
  end
end
