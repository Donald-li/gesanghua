class Admin::FundAdjustAmountsController < Admin::BaseController
  before_action :set_fund, only: [:new, :create]

  def new
  end

  def create
    respond_to do |format|
      if Fund.adjust(@fund.id, adjust_params[:to_fund], adjust_params[:amount])
        format.html { redirect_to admin_fund_categories_path, notice: '调整金额成功。' }
      else
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
