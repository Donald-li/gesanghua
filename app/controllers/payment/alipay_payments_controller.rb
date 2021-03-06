class Payment::AlipayPaymentsController < Payment::BaseController
  skip_before_action :verify_authenticity_token

  def notify
    # require 'alipay'

    # client = Alipay::Client.new(
    #   url: Settings.alipay_api,
    #   app_id: Settings.alipay_app_id,
    #   app_private_key: Settings.alipay_app_private_key,
    #   alipay_public_key: Settings.alipay_public_key
    # )

    # client.verify?(request.request_parameters) 不好用，再去查一次订单状态

    # resp = client.execute(
    #   method: 'alipay.trade.query',
    #   biz_content: {
    #     out_trade_no: params['out_trade_no']
    #   }.to_json(ascii_only: true)
    # )
    #
    # logger.info resp.inspect
    # result_status = JSON.parse(resp)["alipay_trade_query_response"]["trade_status"]

    # PC and 手机版
    # if result_status == 'TRADE_SUCCESS' || result_status == 'TRADE_FINISHED'
    logger.info request.request_parameters.inspect
    if Alipay::Notify.verify?(request.request_parameters, {})
      succ, message = Donation.alipay_payment_success(params)
      render :plain => 'success'
    else
      render :plain => ''
    end

  end

  def batch_notify
    logger.info request.request_parameters.inspect
    if Alipay::Notify.verify?(request.request_parameters, {})
      succ, message = Donation.batch_alipay_payment_success(params)
      render :plain => 'success'
    else
      render :plain => ''
    end
  end

  def success
    render :plain => 'success'
  end

  def failure

  end

end
