class Admin::GoodsApproveLogsController < Admin::GoodsBaseController

  before_action :set_project_apply, only: [:index]
  before_action :set_audit, only: [:destroy]

  def index
    @search = @project_apply.audits.sorted.ransack(params[:q])
    scope = @search.result
    @audits = scope.page(params[:page])
  end

  def destroy
    @audit.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_goods_apply_goods_approve_logs_path), notice: '删除成功。' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project_apply
    @project_apply = ProjectSeasonApply.find(params[:goods_apply_id])
  end

  def set_audit
    @audit = Audit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def audit_params
    params.require(:audit).permit!
  end
end
