class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :login?

  def create
    unless session_params[:login].present?
      return api_error(message: '请输入账号')
    end
    user = User.where('phone = ? or email = ?', session_params[:login], session_params[:login]).first
    unless user.presence
      return api_error(message: '该帐号不存在')
    end
    if user.state === 'disable'
      return api_error(message: '该帐号已被停用')
    end
    if session_params[:password].present?
      if user.authenticate(session_params[:password])
        set_current_user(user)
        return api_success(message: 'login', data: user.session_builder)
      else
        return api_error(message: '用户密码错误')
      end
    elsif session_params[:code].present?
      # 通过验证码登录
      if SmsCode.valid_code?(mobile: session_params[:login], code: session_params[:code], kind: 'login', write_verified: true)
        set_current_user(user)
        return api_success(message: 'login', data: user.session_builder)
      else
        return api_error(message: '验证码错误')
      end
    end
  end

  private

  def session_params
    params.permit(:login, :password, :code)
  end

  def set_current_user(user)
    session[:user_id] = user.id
  end
end
