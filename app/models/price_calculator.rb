module PriceCalculator
  def calculate_total_price(shipping_method)
    case shipping_method
    when Order::SHIPPING_METHOD_GROUND
      taxed_total.round(2)
    when Order::SHIPPING_METHOD_TWO_DAY
      taxed_total + (Order::SHIPPING_METHOD_TWO_DAY_FEE).round(2)
    when Order::SHIPPING_METHOD_OVERNIGHT
      taxed_total + (Order::SHIPPING_METHOD_OVERNIGHT_FEE).round(2)
    end
  end
end
