class Camp::BaseController < ManagementBaseController
  before_action :login_require
  before_action :set_paper_trail_whodunnit

  helper_method :current_user
  layout 'camp'

  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from Exception, :with => :render_500

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

  def render_404(exception = nil)
    logger.error exception.inspect

    render :file => "#{Rails.root}/public/camp-404.html", :status => 404, :layout => false
  end

  def render_500(exception = nil)
    logger.error exception.inspect

    render :file => "#{Rails.root}/public/camp-500.html", :status => 404, :layout => false
  end
end
