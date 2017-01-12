When /^I enter my requirements$/ do
  select 1, from: 'black'
  select 1, from: 'green'
  fill_in 'by_turn', with: 2
end

When /^I click calculate$/ do
  click_link_or_button 'Calculate'
end

Then /^I see the ten most optimised configurations$/ do
  expect(page).to have_content
  'The following mana configurations are the most optimal for your requirements:'
end
