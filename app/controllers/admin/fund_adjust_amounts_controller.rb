class Admin::FundAdjustAmountsController < Admin::BaseController
  before_action :auth_manage_finanical
  before_action :set_fund, only: [:new, :create]

  def new
  end

  def create
    respond_to do |format|
      if Fund.platform_adjust(@fund.id, adjust_params[:to_fund], adjust_params[:amount], current_user)
        format.html { redirect_to admin_fund_categories_path, notice: '调整金额成功。' }
      else
        flash[:alert] = "调整失败"
        format.html { render :new }
      end
    end
  end

  private
  def set_fund
    @fund = Fund.find(params[:fund_id])
  end

  def adjust_params
    params.require(:adjust).permit!
  end
end
