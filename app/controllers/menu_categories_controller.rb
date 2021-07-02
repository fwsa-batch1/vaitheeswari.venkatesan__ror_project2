class MenuCategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render "index"
    # render plain: MenuCategory.all.map { |menu| menu.display_string }.join("\n")
  end

  def create
    new_menu_category = MenuCategory.create!(menu_category_name: params[:menu_category_name].capitalize, status: true)
    redirect_to menu_categories_path
    # render plain: "Created ! #{new_menu_category.display_string} "
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
