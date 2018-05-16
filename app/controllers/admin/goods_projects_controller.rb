class Admin::GoodsProjectsController < Admin::GoodsBaseController
  before_action :set_project_apply, only: [:show, :edit, :accrue, :update, :destroy,:shipment, :create_shipment, :switch, :receive, :done, :cancelled, :refunded]

  def index
    @search = @current_project.applies.raise_project.sorted.ransack(params[:q])
    scope = @search.result.includes(:school, :season)
    @project_applies = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_apply = @current_project.applies.pass.raise_project.new
  end

  def edit
  end

  # 计提管理费
  def accrue
    @item = @project_apply
    @fund = @current_project.fund
    @management_fee = ManagementFee.new
    render template: '/admin/management_fees/accrue'
  end

  def create
    @project_apply = @current_project.applies.new(project_apply_params.merge(project: @current_project, audit_state: 'pass', project_type: 'raise_project'))

    respond_to do |format|
      if @project_apply.save
        @project_apply.update(apply_no: @project_apply.apply_no)
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to admin_goods_projects_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params.merge(project_type: 2))
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to admin_goods_projects_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to admin_goods_projects_path, notice: '删除成功。' }
    end
  end

  def shipment
    @logistic = Logistic.new
  end

  def create_shipment
    @logistic = Logistic.new(logistic_params.merge(owner: @project_apply))
    respond_to do |format|
      if @logistic.save
        @project_apply.to_receive!
        format.html { redirect_to admin_goods_projects_path, notice: '发货成功。' }
      else
        format.html { render :shipment }
      end
    end
  end

  def done
    @project_apply.done!
    respond_to do |format|
      format.html { redirect_to admin_goods_projects_path, notice: '已完成成功。' }
    end
  end

  def cancelled
    @project_apply.cancelled!
    respond_to do |format|
      format.html { redirect_to admin_goods_projects_path, notice: '已取消成功。' }
    end
  end

  def refunded
    @project_apply.refunded!
    respond_to do |format|
      format.html { redirect_to admin_goods_projects_path, notice: '已退款成功。' }
    end
  end

  def switch
    @project_apply.show? ? @project_apply.hidden! : @project_apply.show!
    redirect_to admin_goods_projects_url, notice: @project_apply.show? ? '项目已显示' : '项目已隐藏'
  end

  private
  def set_project_apply
    @project_apply = ProjectSeasonApply.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_apply_params
    params.require(:project_season_apply).permit!
  end

  def logistic_params
    params.require(:logistic).permit!
  end
end
