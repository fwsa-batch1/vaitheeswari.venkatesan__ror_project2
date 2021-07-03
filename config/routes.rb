Rails.application.routes.draw do
  root "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :menu_categories, :menu_items, :users, :cart_items, :carts, :orders, :order_items
  get "/create", to: "order_items#create", as: :create_order_item
  get "/signin" => "sessions#new", as: :new_sessions
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy", as: :destroy_session
  patch "/users/:id/change", to: "users#change", as: :change_role
  post "cart_items/:id/add" => "cart_items#add_item", as: :cart_item_add
  post "cart_items/:id/remove" => "cart_items#remove_item", as: :cart_item_remove
  delete "/delete_cart" => "carts#destroy", as: :destroy_cart
  delete "/delete_order" => "orders#destroy", as: :destroy_order
  get "all_orders", to: "orders#all_orders", as: :all_orders
  get "pending_orders", to: "orders#pending_orders", as: :pending_orders
end
