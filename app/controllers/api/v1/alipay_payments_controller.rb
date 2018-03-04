class Api::V1::AlipayPaymentsController < Api::V1::BaseController
  skip_before_action :login? unless Settings.development_mode

  def h5
    donation = DonateRecord.find params[:order_id]
    pay_url = donation.alipay_prepay_h5
    api_success(data: {payUrl: pay_url})
  end

end
