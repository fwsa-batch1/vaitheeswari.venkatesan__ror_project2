class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :menu_item

  def item_total_price
    self.quantity * self.menu_item_price
  end
end
