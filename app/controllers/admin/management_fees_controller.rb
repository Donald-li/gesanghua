class Admin::ManagementFeesController < Admin::BaseController
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
