require 'highline'
require 'rainbow'
require 'tastevin/agent'
require 'tastevin/config'
require 'thor'

module Tastevin
  class CLI < Thor

    default_task :usage

    desc "usage", "Describe application usage", :hide => true
    def usage
      puts <<-EOF

Tastevin is a command line utility for configuring and monitoring agents.

      EOF
      help
    end

    desc "add <AGENT> <HOST> <PORT>", "Add an agent"
    def add(agent, host, port)
      highline = HighLine.new

      username = highline.ask("Username: ")
      password = highline.ask("Password: ") { |q| q.echo = '*' }

      config = Config.load

      config.add(agent, host, port, username, password)
      config.save
    end

    desc "rm <AGENT>", "Remove an agent"
    def rm(agent)
      config = Config.load
      check_agent_exists(agent, config)

      config.remove(agent)
      config.save
    end

    desc "ls [-s|--status]", "List the agents"
    option :status, :aliases => :s, :type => :boolean, :desc => "Show agent status"
    def ls
      config = Config.load

      config.list.each do |name|
        if options[:status]
          username = config[name]['username']
          host     = config[name]['host']
          port     = config[name]['port']

          text = "%-10s  %s@%s:%s" % [name, username, host, port ]

          status = Agent.status(config[name])
          if status == :offline
            puts "#{text} (#{'offline'.color(:red)})"
          else
            puts text
          end
        else
          puts name
        end
      end
    end

    desc "set <AGENT> <KEY> <VALUE>", "Set a configuration value"
    def set(agent, key, value)
      config = Config.load
      check_agent_exists(agent, config)

      communicate(agent) do
        Agent.set(config[agent], key, value)
      end
    end

    desc "get <AGENT> <KEY>", "Get a configuration value"
    def get(agent, key)
      config = Config.load
      check_agent_exists(agent, config)

      communicate(agent) do
        value = Agent.get(config[agent], key)
        if value.length > 0
          puts value
        else
          error("No such key '#{key}' in agent '#{agent}'")
        end
      end
    end

    private

    def communicate(agent, &block)
      begin
        block.call
      rescue ConnectionError
        error("Connection to agent '#{agent}' failed")
      rescue LoginError
        error("Logging into agent '#{agent}' failed")
      rescue Error => e
        error("Operation failed: #{e}")
      end
    end

    def check_agent_exists(agent, config)
      error("No such agent '#{agent}'") unless config.exists? agent
    end

    def error(message)
      abort "tastevin: error: #{message}"
    end

  end
end
