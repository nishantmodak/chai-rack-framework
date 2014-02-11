require 'rack'

module JustRails
  class Application
    def call(env)

      request = Rack::Request.new(env)
      
      kontroller_class, action = parse_request(request)
      controller = kontroller_class.new(env)
      response = controller.send(action)
      
      Rack::Response.new(response)
    end

    def parse_request(req)
      _, kont, action, _after = req.path_info.split('/', 4)
      kont = kont.capitalize # Products
      kont += 'Controller'   # ProductsController
      
      [Object.const_get(kont), action]
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end

  def self.to_underscore(string)
    string.gsub(/::/, '/')
    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .tr('-', '_')
    .downcase
  end

  class Object
      def self.const_missing(name)
        @looked_for ||= {}
        str_name = name.to_s
        fail "Class not found: #{name}" if @looked_for[str_name]
        @looked_for[str_name] = 1
        file = JustRails.to_underscore(str_name)
        require file
        klass = const_get(name)
        return klass if klass
        fail "Class not found: #{name}"
      end
    end
      

end
  