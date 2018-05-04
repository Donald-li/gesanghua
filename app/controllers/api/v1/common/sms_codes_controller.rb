class Api::V1::Common::SmsCodesController < Api::V1::BaseController
  skip_before_action :login?
  
  def create
    code = SmsCode.send_code(params[:mobile], params[:kind])
    if code.valid?
      api_success(message: (Settings.send_sms ? nil : code.code))
    else
      api_error(message: code.errors[:mobile])
    end
  end

end
