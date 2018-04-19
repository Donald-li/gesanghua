class Api::V1::BindPhonesController < Api::V1::BaseController

  def create
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
