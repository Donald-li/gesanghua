class Admin::ManagementFeeMonthsController < Admin::BaseController


  def index
    scope = ManagementFeeMonth.sorted
    respond_to do |format|
      format.html { @months = scope.page(params[:page]) }
      format.xlsx {
        @months = scope.all
        OperateLog.create_export_excel(current_user, '管理费汇总表')
        response.headers['Content-Disposition'] = 'attachment; filename= "管理费汇总表" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def update
    @month = ManagementFeeMonth.find(params[:id])
    if @month.month == Time.now.strftime('%Y-%m')
      flash[:alert] = '不能提取本月的管理费'
      redirect_to referer_or(admin_management_fee_months_url)
    else
      @month.accrued!
      redirect_to referer_or(admin_management_fee_months_url)
    end
  end
end
