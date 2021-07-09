class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in, only: [:create, :new]
  before_action :ensure_owner, only: [:index, :change]

  def new
    current_user
  end

  def index
    if params[:role] == "Clerk"
      @pagy, @users = pagy(User.clerks, items: 5)
    else
      @pagy, @users = pagy(User.customers, items: 5)
    end
    render "index", locals: { section_title: params[:role], users: @users }
  end

  def show
    @user = current_user
    render "show"
  end

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
      UserMailer.registration_confirmation(new_user).deliver_now
      if new_user.role == ""
        new_user.role = "Customer"
        new_user.save
        session[:current_user_id] = new_user.id
        @current_cart = Cart.create!(user_id: session[:current_user_id])
        session[:current_cart_id] = @current_cart.id
        redirect_to menu_categories_path
        @current_cart.update(total_price: @current_cart.cart_total)
      else
        redirect_to users_path(:role => new_user.role)
      end
    else
      flash[:error] = new_user.errors.full_messages.join(", ")
      redirect_to new_user_path
    end
  end

  def update
    current_user.update(user_params)
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
