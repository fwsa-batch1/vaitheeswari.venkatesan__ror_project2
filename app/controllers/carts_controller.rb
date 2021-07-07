class CartsController < ApplicationController
  before_action :ensure_user_logged_in

  def destroy
    cart_items = Cart.find(session[:current_cart_id]).cart_items
    cart_items.each do |cart_item|
      cart_item.destroy
    end
    session[:current_cart_id] = nil
    @current_cart = nil
    redirect_to menu_categories_path
  end
end
