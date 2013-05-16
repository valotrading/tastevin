require 'inifile'

module Tastevin
  class Config

    def self.load
      FileUtils.mkdir_p(path)

      filename = File.join(path, 'agents')
      inifile  = IniFile.new(:filename => filename)

      Config.new(inifile)
    end

    def self.path
      File.join(ENV['HOME'], '.tastevin')
    end

    def [](name)
      @inifile[name]
    end

    def exists?(agent)
      @inifile.has_section? agent
    end

    def list
      @inifile.sections
    end

    def add(agent, host, port, username, password)
      @inifile[agent] = {
        'host'     => host,
        'port'     => port,
        'username' => username,
        'password' => password
      }
    end

    def remove(agent)
      @inifile.delete_section agent
    end

    def save
      @inifile.write
    end

    private

    def initialize(inifile)
      @inifile = inifile
    end

  end
end
