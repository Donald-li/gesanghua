class Api::V1::BaseController < ApplicationController
  # before_action :login?
  before_action :set_paper_trail_whodunnit
  skip_before_action :verify_authenticity_token

  protected
  rescue_from(CanCan::AccessDenied){ deny_access }

  def user_for_paper_trail
    "#{current_user.nickname}(#{current_user.name})" if current_user
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def has_user?
    unless current_user.present?
      return empty_page
    end
  end
  # 错误页面返回，前端监听1804
  def empty_page
    api_error(status: 1804, message: '没有用户信息')
  end

  def json_pagination(list)
    {list: list.current_page, total: list.total_count, page_count: list.total_pages}
  end

  def current_user
    @current_user = User.first  if Settings.development_mode && session[:id].blank? # && request.headers['agent'].to_s == 'mobile'
    @current_user = User.find_by(id: session[:id]) if session[:id].present? && request.headers['agent'].to_s == 'mobile'
    token = request.headers['Authorization'] || params[:auth_token]
    return nil if token.blank? && !Settings.development_mode
    @current_user ||= User.find_by(auth_token: token)
    @current_user
  end

  def set_current_user(new_user)
    session[:id] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
    @current_user = new_user
  end

  def inject_current_user(model)
    model.current_user = current_user
  end

  def has_params!(*args)
    if (miss = args - params.keys.map(&:to_sym)).present?
      api_error(status: 300, message: "必传参数#{miss.join(',')}")
      return false
    end
    return true
  end

  def check_params_in!(key, *values)
    values.map!(&:to_s)
    if (params[key].to_s.split(',') - values).present?
      api_error(status: 301, message: "#{key}参数不合法，合法值为#{values.join(',')}")
      return false
    end
    return true
  end

  def login?
    if current_user.present?
      return true
    else
      api_error(status: 402, message: '用户未登录')
      return false
    end
  end

  def deny_access
    api_error(status: 403, message: '没有权限')
  end

  def api_error(status: 400, message: '错误')
    render json: {status: status, message: message, data: {}}
  end

  def api_success(message: '', data: {})
    render json: {status: 0, message: message, data: data}
  end
end
