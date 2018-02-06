class Admin::BaseController < ManagementBaseController
  before_action :logged_in?
  before_action :set_paper_trail_whodunnit

  helper_method :current_user
  helper_method :current_user
  layout 'admin'

  protected
  def user_for_paper_trail
    "管理员：#{current_user.nickname}" if current_user
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def logged_in?
    if session[:current_user_id].present?
      return true
    else
      redirect_to admin_login_path
    end
  end

  def current_user
    @current_user ||= User.find_by id: session[:current_user_id]
  end

end
