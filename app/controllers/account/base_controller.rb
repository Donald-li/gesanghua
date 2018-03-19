class Account::BaseController < ApplicationController
  before_action :logged_in?
  before_action :set_paper_trail_whodunnit

  def logged_in?
    if session[:current_user_id].present?
      return true
    else
      redirect_to user_login_path
    end
  end
end
