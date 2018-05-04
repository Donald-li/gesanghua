class Api::V1::AlipayPaymentsController < Api::V1::BaseController
  skip_before_action :login?

  def h5
    donation = Donation.find_by(order_no: params[:order_no])
    pay_url = donation.alipay_prepay_h5
    api_success(data: {payUrl: pay_url})
  end

end
