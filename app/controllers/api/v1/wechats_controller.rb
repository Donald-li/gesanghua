# -*- encoding : utf-8 -*-
class Api::V1::WechatsController < Api::V1::BaseController
  skip_before_action :login?
  # skip_before_action :verify_authenticity_token

  # 微信授权
  def authorize
    target_url = params["target_url"]
    scope = "snsapi_userinfo"
    state = "weixin"
    url = $client.authorize_url(params[:redirect_url], scope=scope, state=state)
    api_success data: {url: url}
  end

  #回调
  def callback
    userinfo = get_userinfo
    logger.info(userinfo.inspect)
    api_error(message: '登录时发生了错误') and return if userinfo.result['unionid'].blank?
    user = User.where(openid: userinfo.result['unionid']).first || User.new
    user.attributes = {openid: userinfo.result["unionid"], gender: userinfo.result["sex"], nickname: user.try(:nickname) || userinfo.result["nickname"], profile: userinfo.result}
    logger.info(user.attributes.inspect)
    user.valid?
    logger.info(user.errors.full_messages)
    if user.disable?
      # raise ActionController::RoutingError.new('Not Found')
      return api_error(message: '账号已禁用')
    elsif user.save
      set_current_user(user)
      return api_success(message: 'login', data: user.session_builder)
    end
  end

  private
  def get_userinfo
    token = $client.get_oauth_access_token(params["code"])
    logger.info(token.inspect)
    result = token.result
    openid = result["openid"]
    access_token = result["access_token"]
    $client.get_oauth_userinfo(openid, access_token, lang="zh_CN")
  end

end
