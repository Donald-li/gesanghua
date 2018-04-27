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
      succ, message = Donation.alipay_payment_success(params)
    end

    if succ
      render text: 'success'
    end
  end

  def success
     render(:text => 'success')
  end

  def failure

  end

end
