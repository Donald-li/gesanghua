class Admin::RadioFeedbacksController < Admin::BaseController
  before_action :set_install, only: [:show, :edit, :update, :destroy, :recommend]
  # before_action :set_project, only: [:index]
  before_action :set_project_apply, only: [:index, :new, :create, :update, :destroy, :recommend]

  def index
    @install = @apply.install
  end

  def new
    @install = @apply.install.new
  end

  def edit
  end

  def create
    @install = @apply.install.new(install_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.radio_project.id, project_season_apply_id: install_params[:owner_id], project_season_id: ProjectSeasonApply.find(install_params[:owner_id]).season.id))
    respond_to do |format|
      if @install.save
        format.html { redirect_to admin_radio_project_radio_feedbacks_path(@apply), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @install.update(install_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.radio_project.id, project_season_apply_id: install_params[:owner_id], project_season_id: ProjectSeasonApply.find(install_params[:owner_id]).season.id))
        format.html { redirect_to admin_radio_project_radio_feedbacks_path(@apply), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @install.destroy
    respond_to do |format|
      format.html { redirect_to admin_radio_project_radio_feedbacks_path(@apply), notice: '删除成功。' }
    end
  end

  def recommend
    @install.recommend? ? @install.normal! : @install.recommend!
    redirect_to admin_radio_project_radio_feedbacks_path(@apply), notice:  @install.recommend? ? '已推荐反馈' : '已取消推荐反馈'
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
      @project = Project.find(Project.radio_project.id)
    end

    def set_project_apply
      @apply = ProjectSeasonApply.find(params[:radio_project_id])
    end
end
