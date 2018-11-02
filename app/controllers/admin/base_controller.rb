class Admin::BaseController < ManagementBaseController
  before_action :login_require, :can_entrance
  before_action :set_paper_trail_whodunnit
  # before_action :store_referer, only: [:new, :edit, :destroy]

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

  def can_entrance
    return unless current_user.present?
    @current_entrance_cards ||= EntranceGuard.entrance_cards
    can_entrance = (@current_entrance_cards[request.path_parameters[:controller]][request.path_parameters[:action]].compact.uniq & current_user.roles).present?
    can_project = session[:goods_project_id].present? ? current_user.project_ids.include?(session[:goods_project_id]) : true
    unless can_entrance && can_project
      redirect_to admin_main_path, alert: '您没有权限'
    end
  end

  def current_user
    unless @current_user
      user = User.find_by id: session[:admin_user_id]
      @current_user = user if user && user.has_role?(User::SUPERADMIN_ROLES)
    end
    @current_user
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

  def referer_or(url)
    session.delete(:admin_referer).presence || url
  end

  private
  def store_referer
    session[:admin_referer] = request.referer if request.referer.present? && session[:skip_referer].blank?
    session.delete(:skip_referer) if session[:skip_referer]
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
