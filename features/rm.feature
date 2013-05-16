Feature: tastevin rm

  Scenario: No configured agents
    When I run `tastevin rm agent`
    Then it should fail with:
      """
      tastevin: error: No such agent 'agent'
      """

  Scenario: Configured agents
    Given I configure agent-1 to port 7654
    And I configure agent-2 to port 7655
    When I run `tastevin rm agent-1`
    And I run `tastevin ls`
    Then it should pass with:
      """
      agent-2

      """
