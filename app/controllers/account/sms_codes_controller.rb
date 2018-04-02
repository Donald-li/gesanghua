class Account::SmsCodesController < Account::BaseController
  def create
    byebug
    code = SmsCode.send_code(params[:mobile], params[:kind])
    if code.valid?
      return code.code if !Settings.send_sms?
    else
      return nil
    end
  end

end
