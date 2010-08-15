@organizations
Feature: Managing organizations

  Background: 
    Given I am logged in as mislav
    And the following confirmed users exist
      | login  | email                    | first_name | last_name |
      | pablo  | pablo@teambox.com        | Pablo      | Villalba  |
      | jordi  | jordi@teambox.com        | Jordi      | Romero    |
    And I am currently in the project ruby_rockstars
    And "jordi" is in the project called "Ruby Rockstars"
    And "pablo" is in the project called "Ruby Rockstars"
    And I am an administrator in the organization called "ACME"
    And "pablo" is a participant in the organization called "ACME"
    When I go to the organizations page
    And I follow "ACME"

  Scenario: I view all the projects in my organization
    When I go to the home page
    And I follow "Organizations"
    When I follow "ACME" within ".organizations"
    Then I should see "Ruby Rockstars"

  Scenario: I edit an organization
    When I fill in the following:
      | organization_name       | War Industries |
      | organization_permalink  | acmeind        |
    And I press "Save changes"
    And I go to the organizations page
    Then I should see "War Industries" within ".organizations"

  Scenario: I should see admins, participants and external users from an organization
    When I follow "Manage users"
    Then I should see "Mislav" within ".users_admins"
    And I should see "Pablo" within ".users_participants"
    And I should see "Jordi" within ".users_external"
    And I should not see "Remove admin rights" within ".users_admins"
    And I should not see "remove from this organization" within ".users_admins"

  Scenario: I promote a participant to an admin
    When I follow "Manage users"
    And I follow "Give admin rights"
    Then I should see "Pablo" within ".users_admins"

  Scenario: I remove a participant from an organization
    When I follow "Manage users"
    And I follow "remove from this organization"
    Then I should see "Pablo" within ".users_external"

  Scenario: I promote an external to a participant
    When I follow "Manage users"
    And I follow "Add to the organization as a participant"
    Then I should see "Jordi" within ".users_participants"

  Scenario: I promote an external to an admin
    When I follow "Manage users"
    And I follow "add as an admin"
    Then I should see "Jordi" within ".users_admins"

  Scenario: I promote an admin and then demote him to participant
    When I follow "Manage users"
    And I follow "add as an admin"
    And I follow "Remove admin rights"
    Then I should see "Jordi" within ".users_participants"

  Scenario: I promote an admin and then remove him from the organization
    When I follow "Manage users"
    And I follow "add as an admin"
    And I follow "remove from this organization"
    Then I should see "Jordi" within ".users_external"

  Scenario: I can't manage users as a participant
    Given I log out
    And I am logged in as "pablo"
    When I go to the organizations page
    And I follow "ACME"
    And I follow "Manage users"
    Then I should not see "Remove admin rights" within ".users_admins"
    And I should not see "remove from this organization" within ".users_admins"
    And I should not see "Add to the organization as a participant"
    And I should not see "add as an admin"

  Scenario: I can't see projects I don't belong to as a participant
    Given a project exists with name: "Secret Tactics"
    And the project "Secret Tactics" belongs to "ACME" organization
    And "mislav" is in the project called "Secret Tactics"
    When I go to the organizations page
    And I follow "ACME"
    And I follow "Manage projects"
    Then I should see "Secret Tactics"
    And I log out
    And I am logged in as "pablo"
    When I go to the organizations page
    And I follow "ACME"
    And I follow "Manage projects"
    And I should not see "Secret Tactics"

  Scenario: I can't access organizations as an external user
    Given I log out
    And I am logged in as "jordi"
    When I follow "ACME"
    Then I should see "You don't have permission to access or edit this organization."
    And I should see "Mislav" within ".users_admins"
  