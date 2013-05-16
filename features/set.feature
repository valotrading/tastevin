Feature: tastevin set

  Scenario: No such agent
    When I run `tastevin set agent-1 foo quux`
    Then it should fail with:
      """
      tastevin: error: No such agent 'agent-1'
      """

  Scenario: Agent is offline
    Given I configure agent-1 to port 7654
    When I run `tastevin set agent-1 foo quux`
    Then it should fail with:
      """
      tastevin: error: Connection to agent 'agent-1' failed
      """

  Scenario: Set value
    Given I run agent-1 on port 7654
    When I run `tastevin set agent-1 foo quux`
    Then the exit status should be 0

  Scenario: Get set value
    Given I run agent-1 on port 7654
    And I run `tastevin set agent-1 foo quux`
    When I run `tastevin get agent-1 foo`
    Then it should pass with:
      """
      quux

      """
