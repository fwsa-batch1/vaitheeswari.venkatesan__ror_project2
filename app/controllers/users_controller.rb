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
    if new_user.role == ""
      new_user.role = "Customer"
      if new_user.save
        UserMailer.registration_confirmation(new_user).deliver_now
        session[:current_user_id] = new_user.id
        @current_cart = Cart.create!(user_id: session[:current_user_id])
        session[:current_cart_id] = @current_cart.id
        @current_cart.update(total_price: @current_cart.cart_total)
        redirect_to menu_categories_path
      else
        flash[:error] = new_user.errors.full_messages.join(", ")
        redirect_to new_user_path
      end
    else
      new_user.save
      redirect_to users_path(:role => new_user.role)
    end
  end

  def update
    User.update(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], address: params[:address], phone_number: params[:phone_number])
    redirect_to user_path(id: params[:id])
  end

  def change
    @user = User.find(params[:id])
    @user.change_role
    redirect_to(users_path(:role => @user.role), notice: "#{@user.first_name} role is changed to #{@user.role} ")
  end
end