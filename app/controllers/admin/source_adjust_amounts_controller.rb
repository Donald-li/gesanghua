class Admin::SourceAdjustAmountsController < Admin::BaseController
  before_action :auth_manage_finanical
  before_action :set_income_source

  def new
  end

  def create
    respond_to do |format|
      if IncomeSource.platform_adjust(@income_source.id, adjust_params[:to_source], adjust_params[:amount], current_user)
        format.html { redirect_to admin_income_sources_path, notice: '调整金额成功。' }
      else
        flash[:alert] = "调整失败"
        format.html { render :new }
      end
    end
  end

  def show
    @search = AdjustRecord.where(from_item: @income_source).ransack(params[:q])
    scope = @search.result
    @adjust_records = scope.sorted.page(params[:page])
  end

  private
  def set_income_source
    @income_source = IncomeSource.find(params[:income_source_id])
  end

  def adjust_params
    params.require(:adjust).permit!
  end
end
