class MenuCategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @menu_categories = MenuCategory.active
    if params[:status] == "Inactive"
      @menu_categories = MenuCategory.not_active
    end
    render "index"
  end

  def create
    new_menu_category = MenuCategory.new(menu_category_name: params[:menu_category_name].capitalize, status: true)
    if new_menu_category.save
    else
      flash[:error] = new_menu_category.errors.full_messages.join(", ")
    end
    redirect_to menu_categories_path
  end

  def update
    id = params[:id]
    menu_category_name = params[:menu_category_name]
    status = params[:status]
    # if status == "Active"
    #   status = true
    # else
    #   status = false
    # end
    menu_category = MenuCategory.find(id)
    menu_category.menu_category_name = menu_category_name
    menu_category.status = status
    menu_category.save!
    redirect_to menu_categories_path
  end

  def destroy
    id = params[:id]
    menu_category = MenuCategory.find(id)
    menu_category.destroy
    redirect_to menu_categories_path
  end

  def show()
  end
end
