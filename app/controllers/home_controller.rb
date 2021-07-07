class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in, unless: current_user

  def index
  end
end
