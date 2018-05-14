class Api::V1::Common::SmsCodesController < Api::V1::BaseController
  skip_before_action :login?
  
  def create
    if params[:operate_kind] == 'bind_phone' && User.find_by(phone: params[:mobile]).present?
      api_error(message: '手机号已占用')
    else
      code = SmsCode.send_code(params[:mobile], params[:kind])
      if code.valid?
        api_success(message: (Settings.send_sms ? nil : code.code))
      else
        api_error(message: code.errors[:mobile])
      end
    end

  end

end
