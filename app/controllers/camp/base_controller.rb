class Camp::BaseController < ManagementBaseController
  before_action :login_require
  before_action :set_paper_trail_whodunnit

  helper_method :current_user
  layout 'camp'

  rescue_from Exception, :with => :render_error

  protected
  def user_for_paper_trail
    "管理员：#{current_user.nickname}" if current_user
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def login_require
    if session[:camp_user_id].present?
      return true
    else
      redirect_to camp_login_path
    end
  end

  def current_user
    @current_user ||= User.find_by id: session[:camp_user_id]
  end

  def render_error(exception = nil)
    unless Rails.env == 'development'
      case exception
        when ActiveRecord::RecordNotFound, ActionController::RoutingError
          render :file => "#{Rails.root}/public/admin-404.html", :status => 404, :layout => false
        else
          render :file => "#{Rails.root}/public/admin-500.html", :status => 500, :layout => false
      end
    else
      raise exception
    end
    logger.info exception.try(:inspect)

  end
end
