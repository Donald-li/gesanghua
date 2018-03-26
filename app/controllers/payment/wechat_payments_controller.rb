class Payment::WechatPaymentsController < Payment::BaseController
  skip_before_action :verify_authenticity_token

  def notify
    result = Hash.from_xml(request.body.read)["xml"]
    if WxPay::Sign.verify?(result)
      IncomeRecord.wechat_payment(result, params) if result['result_code'] == 'SUCCESS'
      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

  def success

  end

  def failure

  end

end
