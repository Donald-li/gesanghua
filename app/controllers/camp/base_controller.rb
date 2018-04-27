class Camp::BaseController < ManagementBaseController
  before_action :login_require
  before_action :set_paper_trail_whodunnit

  helper_method :current_user
  layout 'camp'

  protected
  def user_for_paper_trail
    "管理员：#{current_user.nickname}" if current_user
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def login_require
    if session[:user_id].present?
      return true
    else
      redirect_to user_login_path
    end
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

end
