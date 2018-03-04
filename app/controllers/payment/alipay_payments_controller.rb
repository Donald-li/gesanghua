class Payment::AlipayPaymentsController < Payment::BaseController
  skip_before_action :verify_authenticity_token

  def notify
    require 'alipay'

    client = Alipay::Client.new(
      url: Settings.alipay_api,
      app_id: Settings.alipay_app_id,
      app_private_key: Settings.alipay_app_private_key,
      alipay_public_key: Settings.alipay_public_key
    )

    if client.verify?(request.request_parameters) && params['trade_status'] == 'TRADE_SUCCESS'
      record = DonateRecord.find_by(donate_no: params['out_trade_no'])

      if record.unpay?
        record.pay_result = params.to_json
        income_record = IncomeRecord.new(user: record.user, voucher_state: 'to_bill', income_source_id: 1, amount: params['invoice_amount'], income_time: Time.now)
        record.income_record = income_record
        record.pay_state = 'paid'
        record.save
      end
    end

    render text: 'success'
  end

  def success
     render(:text => 'success')
  end

  def failure

  end

end
