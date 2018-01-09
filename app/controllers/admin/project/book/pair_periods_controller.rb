class Admin::PairPeriodsController < Admin::BaseController
  before_action :set_period, only: [:show, :edit, :update, :destroy, :switch, :move]

  def index
    @search = ProjectSeasonApplyPeriod.sorted.ransack(params[:q])
    scope = @search.result
    @pair_periods = scope.page(params[:page])
  end

  def show
  end

  def new
    @pair_period = ProjectSeasonApplyPeriod.new
  end

  def edit
  end

  def create
    @pair_period = ProjectSeasonApplyPeriod.new(period_params)

    respond_to do |format|
      if @pair_period.save
        format.html { redirect_to admin_pair_periods_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @pair_period.update(period_params)
        format.html { redirect_to admin_pair_periods_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @pair_period.destroy
    respond_to do |format|
      format.html { redirect_to admin_pair_periods_path, notice: '删除成功。' }
    end
  end

  def switch
    @pair_period.enabled? ? @pair_period.disabled! : @pair_period.enabled!
    redirect_to referer_or(admin_pair_periods_path), notice: @pair_period.enabled? ? "#{@pair_period.name}已启用" : "#{@pair_period.name}已禁用"
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @pair_period.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period
      @pair_period = ProjectSeasonApplyPeriod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def period_params
      params.require(:project_season_apply_period).permit!
    end
end
