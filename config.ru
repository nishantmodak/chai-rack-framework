require './justrails'
require './config/application'
require './app/controllers/products_controller'

map '/' do
  run ProductsController.action(:index)
end

run JustRailsApp::Application.new
