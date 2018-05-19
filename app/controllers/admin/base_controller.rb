class Admin::BaseController < ManagementBaseController
  before_action :login_require
  before_action :set_paper_trail_whodunnit

  helper_method :current_user
  layout 'admin'

  # rescue_from ActionController::RoutingError, :with => :render_404
  # rescue_from Exception, :with => :render_500
  rescue_from Exception, :with => :render_error
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
      user = User.find_by id: session[:admin_user_id]
      @current_user = user if user && user.has_role?(User::ADMIN_ROLES)
    end
    @current_user
  end

  def auth_superadmin
    authorize! :manage_superadmin, current_user
  end

  def auth_manage_operation
    authorize! :manage_operation, current_user
  end

  def auth_custom_service
    authorize! :manage_custom_service, current_user
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

  def render_error(exception = nil)
    unless Rails.env == 'development'
    case exception
      when ActiveRecord::RecordNotFound, ActionController::RoutingError,
          ::ActionController::UnknownAction
        render :file => "#{Rails.root}/public/admin-404.html", :status => 404, :layout => false
      else
        render :file => "#{Rails.root}/public/admin-500.html", :status => 500, :layout => false
    end
    else
      raise exception
    end
    logger.info exception.try(:inspect)

  end

  # def render_404(exception = nil)
  #   logger.info exception.try(:inspect)
  #
  #   unless Rails.env == 'development'
  #     render :file => "#{Rails.root}/public/admin-404.html", :status => 404, :layout => false
  #   else
  #     raise exception
  #   end
  # end
  #
  # def render_500(exception = nil)
  #   logger.info exception.try(:inspect)
  #
  #   unless Rails.env == 'development'
  #     render :file => "#{Rails.root}/public/admin-500.html", :status => 500, :layout => false
  #   else
  #     raise exception
  #   end
  # end
end
