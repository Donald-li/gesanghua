class Account::BaseController < ApplicationController
  before_action :logged_in?
  before_action :set_paper_trail_whodunnit

  layout 'account'

  protected
  def logged_in?
    if session[:user_id].present?
      return true
    else
      redirect_to account_login_path
    end
  end

end
