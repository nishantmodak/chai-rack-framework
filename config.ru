require './justrails'
require './config/application'
require './app/controllers/products_controller'
require 'http_router'

map "/" do
  run ProductsController.action(:first)
end

r = HttpRouter.new
r.add('/hi').to(ProductsController.action(:first))

app = JustRailsApp::Application.new

app.draw do
  # get '/r' do
  #  ProductsController.action(:first)
  # end
  add('/hi').to(ProductsController.action(:first))
end


run app
