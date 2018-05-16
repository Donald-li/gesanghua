class Api::V1::BindPhonesController < Api::V1::BaseController

  def show
    api_success(data: current_user.password_digest.present?)
  end

  def create
    if SmsCode.valid_code?(mobile: params[:mobile], code: params[:code], kind: 'login', write_verified: true)
      if User.find_by(phone: params[:mobile]).present?
        user = User.find_by(phone: params[:mobile])
        if user.unactived? && user.manager_id.present?
          if user.offline_user_activation(user.phone, current_user)
            set_current_user(user)
            if params[:password].present?
              user.password = params[:password]
              user.save
            end
            api_success(message: '绑定成功', data: {state: true})
          else
            api_success(message: '绑定失败', data: {state: false})
          end
        elsif !user.openid.present?
          User.combine_user(params[:mobile], current_user)
          set_current_user(user)
          user.phone = params[:mobile]
          if params[:password].present?
            user.password = params[:password]
          end
          user.save

          api_success(message: '绑定成功', data: {state: true})
        else
          api_success(message: '绑定失败，手机号已占用', data: {state: false})
        end
      else
        current_user.phone = params[:mobile]
        if params[:password].present?
          current_user.password = params[:password]
        end
        if current_user.save
          current_user.bind_user_roles
          api_success(message: '绑定成功', data: {state: true})
        else
          api_success(message: '绑定失败，手机号已占用', data: {state: false})
        end
      end
    else
      api_error(message: '验证码错误')
    end
  end

  def update
    if SmsCode.valid_code?(mobile: params[:mobile], code: params[:code], kind: 'login', write_verified: true)
      current_user.phone = params[:mobile]
      if current_user.save
        current_user.bind_user_roles
        api_success(message: '绑定成功', data: {state: true})
      else
        api_success(message: '绑定失败，手机号已占用', data: {state: false})
      end
    else
      api_error(message: '验证码错误')
    end
  end

end
