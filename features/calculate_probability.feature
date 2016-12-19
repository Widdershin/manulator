Feature: Users can find out the probability meeting a mana requirement
  We want to give users a simple form that allows them to input the
  number & colour of their mana requirement, and the turn by which
  they need to achieve it. When the user submits the form we'll
  respond the mana configurations that are most likely to fulfill
  those requirements.

   Scenario: User calculates mana configurations for a single requirement
     Given I am on the home page
     When I enter "1" "G" by turn "1" as my requirement
     And I click submit
     Then I see the three most optimised configurations
