$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'app', 'controllers')

module JustRailsApp
  class Application < JustRails::Application
  end
end
