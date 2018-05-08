class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :login?

  def create
    @user = User.new(user_params.slice(:password, :login))
    respond_to do |format|
      if User.find_by_login(user_params[:login])
        u = User.find_by_login(user_params[:login])
        if u.state != 'unactived'
          return api_error(message: '账号已被注册')
        elsif u == 'unactived'
          u.enable!
          # TODO 合并用户
          return api_success(message: '注册成功')
        end
      else
        if user_params[:password].empty?
          return api_error(message: '请输入密码')
        end
        if user_params[:code].empty?
          return api_error(message: '请输入验证码')
        end
        unless SmsCode.valid_code?(mobile: user_params[:login], code: user_params[:code], kind: 'signup')
          return api_error(message: '验证码错误')
        end
        @user.name = user_params[:login]
        @user.phone = user_params[:login]
        if @user.save
          set_current_user(@user)
          return api_success(data: @user.session_builder)
        else
          return api_error(message: '注册时发生了错误')
        end
      end
    end
  end

  private

  def user_params
    params.permit(:login, :password, :code)
  end

  def set_current_user(user)
    session[:current_user_id] = user.id
  end
end
