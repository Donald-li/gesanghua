# -*- encoding : utf-8 -*-
class Site::WechatsController < Site::BaseController
  # skip_before_action :login?
  skip_before_action :verify_authenticity_token

  # #登录
  # def new
  #   target_url = params["target_url"]
  #   scope = "snsapi_userinfo"
  #   state = "weixin"
  #   redirect_uri = callback_wechat_connects_url(host: Settings.app_host, port: 80, target_url: target_url)
  #   redirect_to $wechat_open_client.authorize_url(redirect_uri, scope=scope, state=state)
  # end

  #回调
  def callback
    userinfo = get_userinfo
    logger.info userinfo.inspect
    if userinfo.result['unionid'].blank?
      flash[:alert] = '登录失败'
      redirect_to root_url and return
    end
    user = User.where(openid: userinfo.result['unionid']).first || User.new
    user.attributes = { openid: userinfo.result["unionid"], gender: userinfo.result["sex"], profile: userinfo.result }
    user.name ||= userinfo.result['nickname']
    user.nickname ||= userinfo.result['nickname']
    if user.disable?
      flash[:alert] = '登录失败'
      redirect_to root_url and return
    elsif user.save
      set_current_user(user)
      redirect_to root_url and return
    else
      flash[:alert] = '登录失败'
      redirect_to root_url and return
    end
  end

  private
  def get_userinfo
    result = $wechat_open_client.get_oauth_access_token(params["code"]).result
    logger.info result.inspect
    openid = result["openid"]
    access_token = result["access_token"]
    $wechat_open_client.get_oauth_userinfo(openid, access_token, lang="zh_CN")
  end

end
