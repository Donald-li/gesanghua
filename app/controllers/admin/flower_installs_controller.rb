class Admin::FlowerInstallsController < Admin::BaseController
   # before_action :set_receive, only: [ :update, :destroy]
  # before_action :set_project, only: [:index]
  before_action :set_project_apply, only: [:show, :edit, :new, :create, :update, :destroy]

  def new
    @install = InstallFeedback.new
  end

  def show
    @install = @apply.install
  end

  def edit
    @install = @apply.install
  end

  def create
    @install = @apply.install.new(install_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.care_project.id, project_season_apply_id: install_params[:owner_id], project_season_id: ProjectSeasonApply.find(install_params[:owner_id]).season.id))
    respond_to do |format|
      if @install.save
        format.html { redirect_to admin_flower_project_flower_install_path(@apply), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @install = @apply.install
    respond_to do |format|
      if @install.update(install_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.care_project.id, project_season_apply_id: install_params[:owner_id], project_season_id: ProjectSeasonApply.find(install_params[:owner_id]).season.id))
        format.html { redirect_to admin_flower_project_flower_install_path(@apply), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @install = @apply.install
    @install.destroy
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_install
      @install = InstallFeedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def install_params
      params.require(:install).permit!
    end

    def set_project
      @project = Project.find(Project.care_project.id)
    end

    def set_project_apply
      @apply = ProjectSeasonApply.find(params[:flower_project_id])
    end
end
