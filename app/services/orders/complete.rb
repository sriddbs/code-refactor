class Order::Complete
  def initialize(params, order)
    @params = params
    @order = order
  end

  def call
    @order.order_status = 'processed'

    ActiveRecord::Base.transaction do
      if @order.save
        destroy_cart
        send_order_confirmation_email
        OpenStruct.new(success?: true, order: @order, message: 'You successfully ordered!')
      else
        OpenStruct.new(success?: false, order: @order, message: 'There was a problem processing your order. Please try again.')
      end
    end
  end

  private

  def destroy_cart
    Cart.destroy(@params[:cart_id])
  end

  def send_order_confirmation_email
    OrderMailer.order_confirmation(@params[:email], @params[:order_id]).deliver_later
  end
end
