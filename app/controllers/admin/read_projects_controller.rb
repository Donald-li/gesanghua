class Admin::ReadProjectsController < Admin::BaseController
  before_action :set_project, only: [:edit, :update, :switch]

  def index
    @search = ProjectSeasonApply.where(project_id: 2).raise_project.sorted.ransack(params[:q])
    scope = @search.result.joins(:school)
    @projects = scope.page(params[:page])
  end

  def edit
  end

  def update
    @project.attach_cover_image(params[:cover_image_id])
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to admin_read_projects_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def switch
    @project.show? ? @project.hidden! : @project.show!
    redirect_to admin_read_projects_url, notice: @project.show? ? '项目已启用' : '项目已暂停'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = ProjectSeasonApply.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project_season_apply).permit!
  end
end
