class Admin::BaseController < ManagementBaseController
  before_action :login_require
  before_action :set_paper_trail_whodunnit

  helper_method :current_user
  layout 'admin'

  protected
  def user_for_paper_trail
    "管理员：#{current_user.nickname}" if current_user
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def login_require
    if current_user.present?
      return true
    else
      redirect_to admin_login_path
    end
  end

  def current_user
    unless @current_user
      user = User.find_by id: session[:user_id]
      @current_user = user if user.has_role? User::ADMIN_ROLES
    end
    @current_user
  end


  def auth_superadmin
    authorize! :manage_superadmin, current_user
  end

  def auth_manage_operation
    authorize! :manage_operation, current_user
  end

  def auth_manage_finanical
    authorize! :manage_financial, current_user
  end

  def auth_manage_project(project=nil)
    authorize! :manage_project, current_user, project
  end

  def auth_operate_project(project=nil)
    authorize! :operate_project, current_user, project
  end

end
