class Payment::WechatPaymentsController < Payment::BaseController
  skip_before_action :verify_authenticity_token

  def notify
    result = Hash.from_xml(request.body.read)["xml"]

    if WxPay::Sign.verify?(result)

      # find your order and process the post-paid logic.
      if result['result_code'] == 'SUCCESS'
        record = DonateRecord.find_by(donate_no: result['out_trade_no'])

        if record.unpay?
          record.pay_result = result.to_json
          income_record = IncomeRecord.new(user: record.user, voucher_state: 'to_bill', income_source_id: 1, amount: result['total_fee'], income_time: Time.now)
          record.income_record = income_record
          record.pay_state = 'paid'
          record.save
        end
      end

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
