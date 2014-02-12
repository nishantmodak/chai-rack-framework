require 'rack'
require 'tilt'

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

    def draw(&block)
      r = HttpRouter.new
      r.instance_eval(&block)
      # @route_set ||= RouteSet.new
      # @route_set.instance_eval(&block)
    end

    def get_rack_app(env)
      @route_set.run_routes env['PATH_INFO']
    end
  end

  class RouteSet
    @@routing_table = Hash.new { |verb, value| verb[value] =  [] }
    def get(path, &block)
      verb = 'GET'
      current = @@routing_table[verb] || []
      current += [[path, block]]
      @@routing_table = @@routing_table.merge(verb => current)
    end

    def run_routes
      @@routing_table[@env['REQUEST_METHOD']].each do |path, block|
        # binding.pry
        if @env['PATH_INFO'] == path
          puts '--------------------------found--------------------'
          puts block.inspect
          response = block.call(@env)
          return response
        end
      end
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def request
      @request = Rack::Request.new(env)
    end

    def params
      request.params.merge @routing_params
    end

    def controller_name
      JustRails.to_underscore(self.class.to_s.gsub(/Controller$/, ''))
      # products
    end

    def render_view(view_name, locals = {})
      file = File.join(File.dirname(__FILE__), 'app','views', controller_name, "#{view_name}.html.erb")
      tempalte = Tilt.new(file)
      tempalte.render(self, locals.merge(:env => env))
    end

    def render(*args)
      response(render_view(*args))
    end

    def response(text, st = 200, headers = {} )
      fail 'Already responded' if @response
      a = [text].flatten
      @response = Rack::Response.new(a, st, headers)
    end

    def get_response
      @response
    end

    def self.action(act, rp = {})
      proc { |e| self.new(e).dispatch(act, rp)}
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = self.send(action)
      if get_response
        st, hd, rs = get_response.to_a
        [st, hd, [rs].flatten]
      else
        [200, {'Content-Type' => 'text/plain'}, [text].flatten]
      end
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
  