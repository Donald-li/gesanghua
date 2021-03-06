include ActionView::Helpers::NumberHelper
include ApplicationHelper

class Api::V1::BaseController < ApplicationController
  before_action :login?
  before_action :set_paper_trail_whodunnit
  skip_before_action :verify_authenticity_token

  protected

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

  def mobile_user_agent?
    session[:format] = params[:save_format] if params[:save_format].present?
    @mobile_user_agent ||= params[:format].to_sym if params[:format].present?
    @mobile_user_agent ||= session[:format].to_sym if session[:format].present?
    @mobile_user_agent ||= :mobile if request.env["HTTP_USER_AGENT"].to_s.downcase =~ /(mobile|android|iphone|micromessenger)/ #.+Safari
    @mobile_user_agent == :mobile
  end

  # 错误页面返回，前端监听1804
  def empty_page
    api_error(status: 1804, message: '没有用户信息')
  end

  def json_pagination(list)
    if list == []
      {current_page: 0, total_count: 0, total_pages: 0}
    else
      {current_page: list.current_page, total_count: list.total_count, total_pages: list.total_pages}
    end
  end

  def current_user
    @current_user ||= User.find 17889 if Settings.development_mode
    # @current_user ||= User.find Settings.api_defautl_user if Rails.env.development? || Settings.api_defautl_user
    token = request.headers['Authorization'] || params[:auth_token]
    return nil if token.blank?
    @current_user ||= User.find_by(auth_token: token)

    # if session[:user_id].present?
    #   @current_user ||= User.find_by(id: session[:user_id])
    #   session[:user_id] = nil unless @current_user
    # end
    @current_user
  end

  def set_current_user(new_user)
    session[:user_id] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
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
    if current_user.present? || Settings.development_mode
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
