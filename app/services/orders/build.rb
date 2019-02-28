class Orders::Build
  def initialize(params, cart)
    @params = params
    @cart = cart
  end

  def call
    order = Order.new(@params)
    # Add items from cart to order's ordered_items association
    order.ordered_items = @cart.ordered_items
    order
  end
end
