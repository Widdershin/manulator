When /^I enter "([^"]*)" "([^"]*)" by turn "([^"]*)" as my requirement$/ do |number, color, turn|
  fill_in 'Number of sources', with: number
  fill_in 'Colour of sources', with: color
  fill_in 'By turn', with: turn
end

Then /^I see the three most optimised configurations$/ do
  expect(page).to have_content
  'The following mana configurations are the most optimal for your requirements:'
end
