class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :menu_item

  def self.menu_item_ids
    all.map { |cart_item| cart_item.menu_item_id }
  end

  def self.quantity
    quantity
  end

  def item_total_price
    self.quantity * self.menu_item_price
  end
end
