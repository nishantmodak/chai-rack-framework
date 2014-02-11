require 'rack'

module JustRails
  class Application
    def call(env)
      Rack::Response.new(env.inspect)
    end
  end
end
  