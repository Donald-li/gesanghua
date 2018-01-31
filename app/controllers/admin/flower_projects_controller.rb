class Admin::FlowerProjectsController < Admin::BaseController
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy]

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
      if @project_apply.update(project_apply_params)
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

  private
  def set_project
    @project = Project.find(6)
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
