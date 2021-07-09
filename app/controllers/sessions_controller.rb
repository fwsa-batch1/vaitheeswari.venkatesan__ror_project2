class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if (user && user.authenticate(params[:password]))
      session[:current_user_id] = user.id
      if user.role != "Owner"
        if Cart.where(user_id: session[:current_user_id]).empty?
          @current_cart = Cart.create!(user_id: session[:current_user_id])
          session[:current_cart_id] = @current_cart.id
        else
          session[:current_cart_id] = Cart.find_by(user_id: session[:current_user_id]).id
        end
      end
      redirect_to menu_categories_path
    else
      flash[:error] = "Your login attempt was invalid. Please retry ."
      redirect_to new_sessions_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to "/"
  end
end
