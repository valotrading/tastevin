require 'wine'

module Tastevin
  class Agent

    def self.status(config)
      begin
        contact(config).release

        :online
      rescue Error
        :offline
      end
    end

    def self.get(config, key)
      contact(config) { |agent| agent.get(key) }
    end

    def self.set(config, key, value)
      contact(config) { |agent| agent.set(key, value) }
    end

    attr_accessor :host, :port

    def get(key)
      @session.get(key)
    end

    def set(key, value)
      @session.set(key, value)
    end

    def release
      @session.close
    end

    private

    def initialize(host, port, session)
      @host = host
      @port = port

      @session = session
    end

    def self.contact(config)
      host     = config['host']
      port     = config['port']
      username = config['username']
      password = config['password']

      session = connect(host, port)
      login(session, username, password)

      agent = new(host, port, session)

      if block_given?
        begin
          yield agent
        ensure
          agent.release
        end
      else
        agent
      end
    end

    private_class_method :contact

    def self.connect(host, port)
      begin
        Wine::Session.connect(host, port)
      rescue Wine::ConnectionRefused
        raise ConnectionError
      end
    end

    private_class_method :connect

    def self.login(session, username, password)
      begin
        unless session.login(username, password)
          session.close
          raise LoginError
        end
      rescue Wine::ProtocolError
        raise Error, "Protocol error"
      rescue Wine::ResponseTimeout
        raise Error, "Response timeout"
      end
    end

    private_class_method :login

  end
end
