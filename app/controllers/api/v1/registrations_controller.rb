class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :login?

  def create
    @user = User.new(user_params.slice(:password, :login))
    respond_to do |format|
      if User.find_by_login(user_params[:login]).present?
        u = User.find_by_login(user_params[:login])
        if u.state != 'unactived'
          return api_error(message: '账号已被注册')
        elsif u.state == 'unactived' && u.manager_id.present?
          if u.offline_user_activation(u.phone, nil) && u.update(user_params)
            set_current_user(u)
            return api_success(data: u.session_builder, message: '账号激活成功')
          else
            return api_success(message: u.errors.full_messages.first)
          end
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

  def regression
    user = match_user(2)
    if user.present?
      set_current_user(user)
      user.enable!
      return api_success(data: user.session_builder)
    else
      return api_error(message: '找回失败')
    end
  end

  def set_password
    user = current_user
    user.password = params[:password]
    if user.save
      return api_success(data: user.session_builder)
    else
      return api_error(message: '设置失败，请重试')
    end
  end

  private

  def user_params
    params.permit(:login, :password, :code, :nickname, :name, :phone, :email)
  end

  def set_current_user(user)
    session[:user_id] = user.id
  end

  def match_user(condition)
    user_library = User.unactived.where(manager_id: nil)
    # 匹配任意两条
    users = {}
    if condition == 2
      users = user_library.where(nickname: user_params[:nickname], name: user_params[:name]) if user_params[:nickname].present? and user_params[:name].present?
      users = user_library.where(nickname: user_params[:nickname], phone: user_params[:phone]) if user_params[:nickname].present? and user_params[:phone].present? && users.empty?
      users = user_library.where(nickname: user_params[:nickname], email: user_params[:email]) if user_params[:nickname].present? and user_params[:email].present? && users.empty?
      users = user_library.where(name: user_params[:name], phone: user_params[:phone]) if user_params[:name].present? and user_params[:phone].present? && users.empty?
      users = user_library.where(name: user_params[:name], email: user_params[:email]) if user_params[:name].present? and user_params[:email].present? && users.empty?
      users = user_library.where(phone: user_params[:phone], email: user_params[:email]) if user_params[:phone].present? and user_params[:email].present? && users.empty?
    end

    # 匹配任意三条
    if users.count > 1
      users = user_library.where(name: user_params[:name], phone: user_params[:phone], email: user_params[:email]) if user_params[:name].present? and user_params[:phone].present? and user_params[:email].present?
      users = user_library.where(nickname: user_params[:nickname], name: user_params[:name], phone: user_params[:phone]) if user_params[:nickname].present? and user_params[:name].present? and user_params[:phone].present? && users.empty?
      users = user_library.where(nickname: user_params[:nickname], name: user_params[:name], email: user_params[:email]) if user_params[:nickname].present? and user_params[:name].present? and user_params[:email].present? && users.empty?
      users = user_library.where(nickname: user_params[:nickname], phone: user_params[:phone], email: user_params[:email]) if user_params[:nickname].present? and user_params[:phone].present? and user_params[:email].present? && users.empty?
    end

    # 匹配全部
    if users.count > 1
      users = user_library.where(nickname: user_params[:nickname], name: user_params[:name], phone: user_params[:phone], email: user_params[:email]) if user_params[:nickname].present? and user_params[:name].present? and user_params[:phone].present? and user_params[:email].present?
    end
    return users.first
  end

end
