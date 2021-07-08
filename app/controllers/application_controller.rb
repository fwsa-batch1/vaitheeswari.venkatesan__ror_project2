class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :ensure_user_logged_in

  def ensure_user_logged_in
    unless current_user
      redirect_to "/"
    else
      if session[:current_cart_id]
        cart = Cart.where(id: session[:current_cart_id])
        if cart.present?
          @current_cart = cart
        else
          session[:current_cart_id] = nil
        end
      end
      if session[:current_cart_id] == nil
        @current_cart = Cart.create!(user_id: session[:current_user_id])
        session[:current_cart_id] = @current_cart.id
        @current_cart.update(total_price: @current_cart.cart_total)
      end
    end
  end

  def ensure_owner
    unless @current_user.is_owner?
      redirect_to(menu_categories_path, alert: "No access for Customers")
    end
  end

  def ensure_clerk
    unless @current_user.is_clerk?
      redirect_to(menu_categories_path, alert: "No access for Customers")
    end
  end

  def current_user
    return @current_user if @current_user
    current_user_id = session[:current_user_id]
    if current_user_id
      @current_user = User.find(current_user_id)
    else
      nil
    end
  end
end
