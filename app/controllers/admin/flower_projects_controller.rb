class Admin::FlowerProjectsController < Admin::BaseController
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy, :shipment, :switch, :receive, :done, :cancelled, :refunded]

  def index
    @search = @project.applies.raise_project.sorted.ransack(params[:q])
    scope = @search.result
    @project_applies = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_apply = @project.applies.pass.raise_project.new
  end

  def edit
  end

  def create
    @project_apply = @project.applies.new(project_apply_params.merge(project: @project, audit_state: 'pass', project_type: 'raise_project'))

    respond_to do |format|
      if @project_apply.save
        @project_apply.update(apply_no: @project_apply.apply_no)
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to admin_flower_projects_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params.merge(project_type: 2))
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to admin_flower_projects_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '删除成功。' }
    end
  end

  def shipment
    @project_apply.to_receive!
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '发货成功。' }
    end
  end

  def receive
    @project_apply.to_feedback!
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '已收货成功。' }
    end
  end

  def done
    @project_apply.done!
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '已完成成功。' }
    end
  end

  def cancelled
    @project_apply.cancelled!
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '已取消成功。' }
    end
  end

  def refunded
    @project_apply.refunded!
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '已退款成功。' }
    end
  end

  def switch
    @project_apply.show? ? @project_apply.hidden! : @project_apply.show!
    redirect_to admin_flower_projects_url, notice: @project_apply.show? ? '项目已显示' : '项目已隐藏'
  end

  private
  def set_project
    @project = Project.care_project
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_project_apply
    @project_apply = ProjectSeasonApply.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_apply_params
    params.require(:project_season_apply).permit!
  end
end
