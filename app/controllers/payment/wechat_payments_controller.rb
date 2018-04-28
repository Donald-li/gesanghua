class Payment::WechatPaymentsController < Payment::BaseController
  skip_before_action :verify_authenticity_token

  def notify
    result = Hash.from_xml(request.body.read)["xml"]
    logger.info result
    donation = Donation.find_by(order_no: result['out_trade_no'])
    url = pay_path(order_no: donation.id)
    if WxPay::Sign.verify?(result)
      succ, message = Donation.wechat_payment_success(result) if result['result_code'] == 'SUCCESS'
      if succ
        ActionCable.server.broadcast("order_#{donation.order_no}", {result: true, url: url})
        render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
      else
        ActionCable.server.broadcast("order_#{donation.order_no}", {result: false, url: url})
        render :xml => {return_code: "FAIL", return_msg: "捐款失败"}.to_xml(root: 'xml', dasherize: false)
      end
    else
      ActionCable.server.broadcast("order_#{donation.order_no}", {result: false, url: url})
      render :xml => {return_code: "FAIL", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

  def success

  end

  def failure

  end

end
