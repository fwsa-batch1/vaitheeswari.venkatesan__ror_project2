class Cart < ActiveRecord::Base
  has_many :cart_items
  belongs_to :user

  def cart_total
    total = 0
    if self.cart_items
      self.cart_items.each do |cart_item|
        total += cart_item.item_total_price
      end
    end
    return total
  end
end
