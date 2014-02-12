require './justrails'
require './config/application'
require './app/controllers/products_controller'

app = JustRailsApp::Application.new

app.draw do
  get '/' do
    ProductsController.action(:index)
  end

  get '/first' do
    ProductsController.action(:first)
  end

  get '/hello' do
    ProductsController.action(:hello)
  end
end

run app
