class Order::Process
  def initialize(order, params)
    @order = order
    @params = params
  end

  def call
    process_payment
  end

  private

  attr_reader :params, :order

  def process_payment
    # Add shipping and tax to order total
    order.total = order.calculate_total_price(params.dig(:order, :shipping_method))

    # Process credit card
    credit_card = Payments::CreditCard.new(params).call

    if credit_card.valid?
      response = credit_card.charge(order.total)
      if !response.success?
        OpenStruct.new(success?: false, order: order, message: 'We couldn\'t process your credit card')
      end
    else
      OpenStruct.new(success?: false, order: order, message: 'Your credit card seems to be invalid')
    end
  end
end
