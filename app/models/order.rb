class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :user

  def self.pending_orders
    all.where(pending: true)
  end

  def order_total
    total = 0
    if self.order_items
      self.order_items.each do |order_item|
        total += order_item.item_total_price
      end
    end
    return total
  end
end
