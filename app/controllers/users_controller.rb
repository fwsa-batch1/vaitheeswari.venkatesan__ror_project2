class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in, only: [:create, :new]

  def new
    render "new"
  end

  # To show all the users
  def index
    if params[:role] == "Clerk"
      @pagy, @users = pagy(User.clerks, items: 5)
    else
      @pagy, @users = pagy(User.customers, items: 5)
    end
    render "index", locals: { section_title: params[:role], users: @users }
  end

  def show
    @user = User.find(params[:id])
    render "show"
  end

  # To create a new user
  def create
    new_user = User.new(
      first_name: params[:first_name].capitalize,
      last_name: params[:last_name].capitalize,
      email: params[:email],
      password: params[:password],
      role: params[:role],
      phone_number: params[:phone_number],
      address: params[:address],
    )
    if new_user.save
      # UserMailer.registration_confirmation(new_user).deliver_now
      session[:current_user_id] = new_user.id
      @current_cart = Cart.create!(user_id: session[:current_user_id])
      session[:current_cart_id] = @current_cart.id
      if new_user.role == ""
        new_user.role = "Customer"
        new_user.save
        redirect_to menu_categories_path
      else
        redirect_to users_path(:role => new_user.role)
      end
      @current_cart.update(total_price: @current_cart.cart_total)
    else
      flash[:error] = new_user.errors.full_messages.join(", ")
      redirect_to new_user_path
    end
  end

  def update
    User.find(params[:id]).update(user_params)
    redirect_to user_path(id: params[:id])
  end

  def change
    @user = User.find(params[:id])
    @user.change_role
    redirect_to(users_path(:role => @user.role), notice: "#{@user.first_name} role is changed to #{@user.role} ")
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :phone_number, :address)
  end
end
