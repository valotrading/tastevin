Feature: tastevin add

  Scenario: Add an agent
    When I run `tastevin add agent-1 localhost 7654` interactively
    And I type "foo"
    And I type "bar"
    Then the exit status should be 0
