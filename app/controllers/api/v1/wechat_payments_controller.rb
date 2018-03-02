class Api::V1::WechatPaymentsController < Api::V1::BaseController
  skip_before_action :login? unless Settings.development_mode

  def pay
    donation = DonateRecord.find params[:order_id]
    prepay_js = donation.wechat_prepay_js(request.remote_ip)
    api_success(data: {prepayJs: prepay_js})
  end

  def h5
    donation = DonateRecord.find params[:order_id]
    prepay_h5 = donation.wechat_prepay_h5(request.remote_ip)
    api_success(data: {prepayH5: prepay_h5})
  end

end
