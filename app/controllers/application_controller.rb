class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :current_user

  protected
  def logged_in?
    if session[:user_id].present?
      return true
    else
      return false
      # redirect_to account_login_path
    end
  end

  def login_require
    unless logged_in?
      session[:return_path] ||= request.url if request.get?
      redirect_to account_login_path
    end
  end

  # 修改日期选择查询中最后一天
  def set_search_end_of_day(attr=:created_at_lteqeq)
    return unless params[:q]
    return unless params[:q][attr].present?
    params[:q][attr] = Date.parse(params[:q][attr]).end_of_day
  end

  def current_user
    # @current_user = User.second if Settings.development_mode
    @current_user ||= login_from_session
  end

  def login_from_session
    return unless session[:user_id]
    user = User.find_by(id: session[:user_id])
    set_current_user user
    reset_session unless @current_user
    return @current_user
  end

  def set_current_user(new_user)
    session[:user_id] = new_user.try(:id)
    @current_user = new_user
  end

  def json_pagination(list)
    {current_page: list.current_page, total_count: list.total_count, total_pages: list.total_pages}
  end

  def gen_success_message
    render json: {"code"=> 0, "msg"=> "修改成功"}
    flash[:notice] = '操作成功'
  end

  def gen_failure_message(entity =nil)
    if entity.present? && entity.errors.present?
      msg = entity.errors.full_messages.join(',  ')
    end
    render json: {"code"=>"false", "msg"=> msg || "操作失败"}
    flash[:notice] = msg
  end

end
