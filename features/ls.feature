Feature: tastevin ls

  Scenario: No configured agents
    When I run `tastevin ls`
    Then it should pass with exactly:
      """
      """

  Scenario: Configured agents
    Given I configure agent-1 to port 7654
    Given I configure agent-2 to port 7655
    When I run `tastevin ls`
    Then it should pass with:
      """
      agent-1
      agent-2

      """

  Scenario: Configured agents offline
    Given I configure agent-1 to port 7654
    When I run `tastevin ls --status`
    Then it should pass with:
      """
      agent-1     alice@localhost:7654 (offline)

      """

  Scenario: Configured agents online
    Given I run agent-1 on port 7654
    When I run `tastevin ls --status`
    Then it should pass with:
      """
      agent-1     alice@localhost:7654

      """
