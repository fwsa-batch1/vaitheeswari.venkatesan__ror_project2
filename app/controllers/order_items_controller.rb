class OrderItemsController < ApplicationController
  before_action :ensure_user_logged_in

  def create
    cart_items = CartItem.where(cart_id: Cart.find(params[:cart_id]))
    order = Order.find(params[:id])
    cart_items.each do |cart_item|
      new_order_item = OrderItem.create!(
        order_id: order.id,
        menu_item_id: cart_item.menu_item_id,
        menu_item_name: cart_item.menu_item_name,
        menu_item_price: cart_item.menu_item_price,
        quantity: cart_item.quantity,
        total: cart_item.total,
      )
    end
    Cart.find(params[:cart_id]).destroy
    redirect_to orders_path(:id => order.id)
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    redirect_back(fallback_location: root_path)
  end
end
