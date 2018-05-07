class Api::V1::WechatPaymentsController < Api::V1::BaseController
  skip_before_action :login?

  def pay
    donation = Donation.find_by(order_no: params[:order_no])
    prepay_js = donation.wechat_prepay_js(request.remote_ip)
    api_success(data: {prepayJs: prepay_js})
  end

  # TODO: params[:order_id]参数需要换成:order_no
  def h5
    donation = Donation.find_by(order_no: params[:order_no])
    prepay_h5 = donation.wechat_prepay_h5(request.remote_ip)
    api_success(data: {prepayH5: prepay_h5})
  end

end
