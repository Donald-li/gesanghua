class Api::V1::Common::SmsCodesController < Api::V1::BaseController
  skip_before_action :login?

  def create
    user = User.find_by(phone: params[:mobile])
    if user.present? && current_user != user
      type = user.unactived? ? 'offline_active' : 'user_combine'
    end
    if params[:kind] == 'signup' && !mobile_user_agent? && !verify_rucaptcha?
      api_error(message: '请输入图形验证码') and return
    end
    code = SmsCode.send_code(params[:mobile], params[:kind], ip: request.remote_ip)
    if code.valid?
      api_success(message: (Settings.send_sms ? nil : code.code), data: {type: type})
    else
      api_error(message: code.errors[:mobile])
    end

  end

end
