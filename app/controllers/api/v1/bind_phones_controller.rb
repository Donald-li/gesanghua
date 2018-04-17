class Api::V1::BindPhonesController < Api::V1::BaseController
  before_action :set_bookshelf, only: [:define_name, :update, :edit]

  def create
    if SmsCode.valid_code?(mobile: params[:mobile], code: params[:code], kind: 'login', write_verified: true)
      current_user.phone = params[:mobile]
      current_user.save!
      current_user.bind_user_roles
      api_success(message: '绑定成功！', data: {state: true})
    else
      api_error(message: '验证码错误！')
    end
  end

end
