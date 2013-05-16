Feature: tastevin get

  Scenario: No such agent
    When I run `tastevin get agent-1 foo`
    Then it should fail with:
      """
      tastevin: error: No such agent 'agent-1'
      """

  Scenario: Agent is offline
    Given I configure agent-1 to port 7654
    When I run `tastevin get agent-1 foo`
    Then it should fail with:
      """
      tastevin: error: Connection to agent 'agent-1' failed
      """

  Scenario: No such key in agent
    Given I run agent-1 on port 7654
    When I run `tastevin get agent-1 foo`
    Then it should fail with:
      """
      tastevin: error: No such key 'foo' in agent 'agent-1'
      """
