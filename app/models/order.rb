class Order < ApplicationRecord
  include PriceCalculator

  has_many :ordered_items

  SHIPPING_METHOD_GROUND = 'ground'.freeze
  SHIPPING_METHOD_TWO_DAY = 'two-day'.freeze
  SHIPPING_METHOD_OVERNIGHT = 'overnight'.freeze

  SHIPPING_METHOD_TWO_DAY_FEE = 15.75
  SHIPPING_METHOD_OVERNIGHT_FEE = 25
end
