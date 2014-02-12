class ProductsController < JustRails::Controller

  def first
    # 'Hello World'
    render_view :first, { x: 10 }
  end

end
