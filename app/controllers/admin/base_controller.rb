class Admin::BaseController < ManagementBaseController
  before_action :logged_in?
  before_action :set_paper_trail_whodunnit

  helper_method :current_administrator
  layout 'admin'

  protected
  def user_for_paper_trail
    "管理员：#{current_administrator.nickname}" if current_administrator
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def logged_in?
    if session[:current_admin_id].present?
      return true
    else
      redirect_to admin_login_path
    end
  end

  def current_administrator
    @current_administrator ||= Administrator.find_by id: session[:current_admin_id]
  end

end
