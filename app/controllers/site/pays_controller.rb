class Site::PaysController < Site::BaseController

  def new
    @donation = Donation.find_by order_no: params[:order_no]
    # @ali_pay_url = @donation.alipay_prepay_page
    @wechat_code_url = @donation.wechat_prepay_code request.remote_ip
  end

  def show
    @donation = Donation.find_by order_no: params[:order_no]
    if @donation.unpaid?
      redirect_to failure_pay_url(order_no: params[:order_no])
    end
  end

  def failure
    @donation = Donation.find_by order_no: params[:order_no]
  end

end
