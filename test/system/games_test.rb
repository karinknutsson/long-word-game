require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    page.assert_selector('div.letter-box', count: 10)
    # assert_selector "li", count: 10
  end
end
