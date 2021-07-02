class CartItemsController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    @cart = Cart.find(session[:current_cart_id])
    @cart.update(total_price: @cart.cart_total)
    @cart_items = CartItem.where("cart_id = ? ", @cart.id)
    render "index"
  end

  def create
    menu_item = MenuItem.find(params[:menu_item_id])
    new_cart_item = CartItem.create!(
      cart_id: session[:current_cart_id],
      menu_item_id: menu_item.id,
      menu_item_name: menu_item.name,
      menu_item_price: menu_item.price,
      quantity: 1,
      total: menu_item.price,
    )
    # render plain: "#{session[:current_cart_id]} #{menu_item.id} #{menu_item.name} #{menu_item.price}"
    redirect_back(fallback_location: root_path)
  end

  def add_item
    @cart_item = CartItem.find(params[:id])
    @cart_item.quantity += 1
    @cart_item.save
    @cart_item.update(total: @cart_item.item_total_price)
    redirect_back(fallback_location: root_path)
  end

  def remove_item
    @cart_item = CartItem.find(params[:id])
    if @cart_item.quantity > 1
      @cart_item.quantity -= 1
      @cart_item.save
    else
      @cart_item.destroy
    end
    @cart_item.update(total: @cart_item.item_total_price)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_back(fallback_location: root_path)
  end
end
