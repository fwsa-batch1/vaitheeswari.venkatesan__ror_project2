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
      shipping_address: params[:shipping_address],
      billing_address: params[:billing_address],
    )
    if @current_user.is_clerk?
      new_order.update(pending: false, delivered_at: "Walk In Customer")
    else
      MailWorker.perform_async( @current_user.id,"order_confirmation",new_order.id)
      # UserMailer.with(order: new_order, user: @current_user).order_confirmation.deliver_now
    end
    redirect_to create_order_item_path(:id => new_order.id, :cart_id => cart.id)
  end

  def all_orders
    user = User.find(params[:id])
    if current_user.is_owner? and user.is_owner?
      orders = Order.all
      if params[:from_date] && params[:to_date]
        orders = Order.where("order_placed >= ? AND order_placed <= ?", params[:from_date], params[:to_date])
      end
      @pagy, @orders = pagy(orders, items: 5)
    elsif current_user.is_owner?
      orders = user.orders
      if params[:from_date] && params[:to_date]
        orders = user.orders.where("order_placed >= ? AND order_placed <= ?", params[:from_date], params[:to_date])
      end
      @pagy, @orders = pagy(orders, items: 5)
      user_name = user.first_name.capitalize
    else
      @pagy, @orders = pagy(current_user.orders, items: 5)
      user_name = current_user.first_name.capitalize
    end
    render "orders", locals: { user_id: user.id, user: user_name, section_title: "Orders", orders: @orders.order(pending: :desc, id: :desc) }
  end

  def pending_orders
    if current_user.is_owner? || current_user.is_clerk?
      @pagy, @orders = pagy(Order.pending_orders, items: 5)
    else
      @pagy, @orders = pagy(current_user.orders.pending_orders, items: 5)
      user_name = current_user.first_name.capitalize
    end
    render "orders", locals: { user: user_name, section_title: "Pending Orders", orders: @orders.order(id: :desc) }
  end

  def update
    @order = Order.find(params[:id])
    @order.update(pending: false)
    delivered_at = @order.updated_at.in_time_zone("Chennai").strftime("%I:%M %P")
    @order.update(delivered_at: delivered_at)
    MailWorker.perform_async( @order.user_id,"order_delivered",@order.id)
    # UserMailer.with(order: @order, user: User.find(@order.user_id)).order_delivered.deliver_now
    redirect_back(fallback_location: root_path)
  end

  def cancel_order
    @order = Order.find(params[:id])
    @order.update(pending: false)
    @order.update(delivered_at: "Canceled")
    MailWorker.perform_async( @current_user.id,"order_cancelled",@order.id)
    # UserMailer.with(order: @order, user: @current_user).order_cancelled.deliver_now
    redirect_back(fallback_location: root_path)
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy
    redirect_to menu_categories_path
  end
end
