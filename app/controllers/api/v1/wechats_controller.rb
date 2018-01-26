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
    user = User.where(openid: userinfo.result['openid']).first || User.new
    user.attributes = { openid: userinfo.result["openid"], gender: userinfo.result["sex"], name: userinfo.result["nickname"], login: userinfo.result["nickname"], nickname: userinfo.result["nickname"], profile: userinfo.result }
    # user.password = '11111111'
    # user.password_confirmation = '11111111'
    if user.disable?
      raise ActionController::RoutingError.new('Not Found')
    elsif user.save
      set_current_user(user)
      return api_success(message: 'login', data: user.summary_builder.merge(auth_token: user.auth_token))
    end
  end

private
  def get_userinfo
    result = $client.get_oauth_access_token(params["code"]).result
    openid = result["openid"]
    access_token = result["access_token"]
    $client.get_oauth_userinfo(openid, access_token, lang="zh_CN")
  end

end
