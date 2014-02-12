class ProductsController < JustRails::Controller

  def first
    # 'Hello World'
    render :first
  end

  def index
    'This is Root'
  end

  def hello
    render :hello
  end

end
