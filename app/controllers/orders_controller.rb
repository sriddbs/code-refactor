class OrdersController < ApplicationController
  before_action :get_cart

  # process order
  def create
    @order = initialize_order
    process_order
    complete_order
  end

  private

  def initialize_order
    Order::Build.new(order_params, @cart).call
  end

  def process_order
    result = Order::Process.new(params, @order).call

    unless result.success?
      @order.errors.add(result.message)
      flash[:error] = "There was a problem processing your order. Please try again."
      render :new && return
    end
  end

  def complete_order
    attributes = {
      email: order_params.dig(:order, :billing_email),
      cart_id: session[:cart_id],
      order_id: session[:order_id]
    }

    result = Order::Complete.new(attributes, @order)
    if result.success?
      flash[:success] = result.message
      redirect_to confirmation_orders_path
    else
      flash[:error] = result.message
      render :new
    end

  end

  def order_params
    params.require(:order).permit!
  end

  def get_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
  end
end
