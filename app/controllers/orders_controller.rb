class OrdersController < ApplicationController
  before_action :ensure_user_logged_in

  def index
    @order = Order.find(params[:id])
    @order.update(total_price: @order.order_total)
    render "index"
  end

  def create
    cart = Cart.find(params[:id])
    new_order = Order.create!(
      user_id: session[:current_user_id],
      total_price: cart.total_price,
      paid: true,
      pending: true,
      delivered_at: "Pending",
      order_placed: Date.today,
    )
    if @current_user.is_clerk?
      new_order.update(pending: false, delivered_at: "Walk In Customer")
    end
    # render plain: "#{cart.total_price}"
    redirect_to create_order_item_path(:id => new_order.id, :cart_id => cart.id)
  end

  def all_orders
    if current_user.is_owner?
      @pagy, @orders = pagy(Order.all, items: 5)
    else
      user = User.find(params[:id])
      @pagy, @orders = pagy(user.orders, items: 5)
      user_name = user.first_name.capitalize
    end
    render "orders", locals: { user: user_name, section_title: "Orders", orders: @orders.order(id: :desc) }
  end

  def pending_orders
    if current_user.is_owner? || current_user.is_clerk?
      @pagy, @orders = pagy(Order.pending_orders, items: 5)
    else
      user = User.find(params[:id])
      @pagy, @orders = pagy(user.orders.pending_orders, items: 5)
      user_name = user.first_name.capitalize
    end
    render "orders", locals: { user: user_name, section_title: "Pending Orders", orders: @orders.order(id: :desc) }
  end

  def update
    @order = Order.find(params[:id])
    @order.update(pending: false)
    delivered_at = @order.updated_at.strftime("%I:%M %P")
    @order.update(delivered_at: delivered_at)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy
    redirect_to menu_categories_path
  end
end
