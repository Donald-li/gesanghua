class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :login?

  def create
    user = User.where('phone = ? or email = ?', session_params[:login], session_params[:login]).first
    unless user.presence
      return api_error(message: '该帐号不存在')
    end
    if user.state === 'disable'
      return api_error(message: '该帐号已被停用')
    end
    if user.authenticate(session_params[:password])
      set_current_user(user)
      return api_success(message: 'login', data: user.session_builder)
    else
      return api_error(message: '用户密码错误')
    end
  end

  private

  def session_params
    params.permit(:login, :password)
  end

  def set_current_user(user)
    session[:current_user_id] = user.id
  end
end
