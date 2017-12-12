class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
  # 修改日期选择查询中最后一天
  def set_search_end_of_day(attr=:created_at_lteqeq)
    return unless params[:q]
    return unless params[:q][attr].present?
    params[:q][attr] = Date.parse(params[:q][attr].end_of_day)
  end

  def current_user
    @current_user ||= (login_from_session )
  end

  def login_from_session
    return unless session[:user_id]
    user = User.find_by(openid: session[:user_id])
    set_current_user user
    reset_session unless @current_user
    return @current_user
  end
end
