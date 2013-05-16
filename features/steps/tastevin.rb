require 'logger'
require 'wine'

agents = {}

After do
  agents.each do |agent, thread|
    agent.stop
    thread.join
  end

  agents.clear
end

Given /^I run an agent on port (\d+)$/ do |port|
  log    = Logger.new(StringIO.new)
  agent  = Wine::TestServer.new(port, log)
  thread = Thread.new { agent.run }

  agents[agent] = thread
end

Given /^I wait for a file named "([^"]*)" to be created$/ do |filename|
  step "a file named \"#{filename}\" should exist"
end

Given /^I configure ([^ ]+) to port (\d+)$/ do |agent, port|
  step "I run `tastevin add #{agent} localhost #{port}` interactively"
  step "I type \"alice\""
  step "I type \"secret\""
  step "I wait for a file named \"home/.tastevin/agents\" to be created"
end

Given /^I run ([^ ]+) on port (\d+)$/ do |agent, port|
  step "I run an agent on port #{port}"
  step "I configure \"#{agent}\" to port #{port}"
end
