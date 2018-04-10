class Admin::ProjectsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @search = Project.sorted.ransack(params[:q])
    scope = @search.result
    @projects = scope.page(params[:page])
  end

  def show
  end

  def new
    @project = Project.new(kind: :goods)
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.kind = :goods #只能增加物资类项目
    @project.apply_kind = :user_apply #用户申请

    respond_to do |format|
      if @project.save
        @project.attach_image(params[:image_id])
        @project.attach_head_image(params[:head_image_id])
        @project.attach_icon(params[:icon_id])
        format.html { redirect_to admin_projects_path, notice: '新增自定义项目成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        @project.attach_image(params[:image_id])
        @project.attach_head_image(params[:head_image_id])
        @project.attach_icon(params[:icon_id])
        format.html { redirect_to admin_projects_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to admin_projects_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit!
    end
end
