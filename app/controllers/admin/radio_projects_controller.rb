class Admin::RadioProjectsController < Admin::BaseController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = ProjectSeasonApply.where(project_id: 5).pass.raise_project.sorted.ransack(params[:q])
    scope = @search.result.joins(:school)
    @projects = scope.page(params[:page])
  end

  def show
  end

  def new
    @project = ProjectSeasonApply.new
  end

  def edit
  end

  def create
    @project = ProjectSeasonApply.new(project_params.merge(audit_state: 'pass', project_type: 'raise_project'))

    respond_to do |format|
      if @project.save
        @project.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to admin_radio_projects_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params.merge(project_type: 'raise_project'))
        @project.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to admin_radio_projects_path, notice: '设置成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to admin_radio_projects_path, notice: '删除成功。' }
    end
  end

  def switch
    @project.show? ? @project.hidden! : @project.show!
    redirect_to admin_radio_projects_url, notice:  @project.show? ? '对外展示' : '暂不展示'
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
