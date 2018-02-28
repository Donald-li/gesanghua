class Api::V1::WechatPaymentsController < Api::V1::BaseController

  def pay
    donation = DonateRecord.find params[:order_id]
    prepay_js = donation.wechat_prepay_js(request.remote_ip)
    api_success(data: {prepayJs: prepay_js})
  end

end
