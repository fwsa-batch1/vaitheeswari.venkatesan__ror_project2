class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in if !@current_user

  def index
  end
end
