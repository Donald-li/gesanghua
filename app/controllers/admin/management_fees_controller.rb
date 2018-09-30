class Admin::ManagementFeesController < Admin::BaseController


  def index
    scope = ManagementFee.sorted.includes(:month, :owner)
    scope = scope.where(month_id: params[:month_id])
    respond_to do |format|
      format.html { @fees = scope.page(params[:page]) }
      format.xlsx {
        @fees = scope.all
        OperateLog.create_export_excel(current_user, '管理费明细表')
        response.headers['Content-Disposition'] = 'attachment; filename= "管理费明细表" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
    @fee = ManagementFee.find(params[:id])
    @donate_records = DonateRecord.sorted.where(owner_type: @fee.owner_type, owner_id: @fee.owner_id).sorted.page(params[:page])
  end

  def create
    manage_param = params.require(:management_fee).permit!
    if ManagementFee.accrue_management_fee(
      owner_type: manage_param[:owner_type],
      owner_id: manage_param[:owner_id],
      total_amount: manage_param[:total_amount],
      fund_id: manage_param[:fund_id],
      amount: manage_param[:amount],
      user: current_user )
      flash[:notice] = '计提管理费成功'
      redirect_to params[:url]
    else
      flash[:alert] = '计提管理费失败'
      redirect_to params[:url]
    end
  end
end
