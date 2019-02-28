class Cart < ApplicationRecord
  has_many :ordered_items
  has_many :products, through: :ordered_items
end
