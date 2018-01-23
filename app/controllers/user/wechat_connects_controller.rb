# -*- encoding : utf-8 -*-
class User::WechatConnectsController < ApplicationController
  skip_before_action :verify_authenticity_token

  #登录
  def new
    target_url = params["target_url"]
    scope = "snsapi_userinfo"
    state = "weixin"
    redirect_uri = callback_wechat_connects_url(host: Settings.app_host, port: 80, target_url: target_url)
    redirect_to $client.authorize_url(redirect_uri, scope=scope, state=state)
  end

  #回调
  def callback
    userinfo = get_userinfo
    user = User.where(openid: userinfo.result['openid']).first || User.new
    user.attributes = { openid: userinfo.result["openid"], gender: userinfo.result["sex"],  nickname: userinfo.result["nickname"], profile: userinfo.result }
    if user.disable?
      raise ActionController::RoutingError.new('Not Found')
    elsif user.save
      set_current_user(user)
      redirect_to params["target_url"]
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
