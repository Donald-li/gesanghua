class Site::PaysController < Site::BaseController

  def show
    donation = Donation.find_by order_no: params[:order_no]
    @ali_pay_url = donation.alipay_prepay_page
  end

end
