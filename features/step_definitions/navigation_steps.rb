Given /^I am on the home page$/ do
  visit root_path
end

When /^I click submit$/ do
  click_link_or_button 'Submit'
end
