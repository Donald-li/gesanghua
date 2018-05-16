class Admin::ManagementFeeMonthsController < Admin::BaseController
  before_action :auth_manage_finanical

  def index
    scope = ManagementFeeMonth.sorted
    respond_to do |format|
      format.html { @months = scope.page(params[:page]) }
      format.xlsx {
        @months = scope.all
        response.headers['Content-Disposition'] = 'attachment; filename= "管理费汇总表" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def update
    @month = ManagementFeeMonth.find(params[:id])
    if @month.month == Time.now.strftime('%Y-%m')
      flash[:alert] = '不能提取本月的管理费'
      redirect_to admin_management_fee_months_url
    else
      @month.accrued!
      redirect_to admin_management_fee_months_url
    end
  end
end
