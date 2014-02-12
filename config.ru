require './justrails'
require './config/application'
require './app/controllers/products_controller'
require 'http_router'

router = HttpRouter.new
router.add('/hello').to(ProductsController.action(:hello))

run router

map '/first' do
  run ProductsController.action(:first)
end
