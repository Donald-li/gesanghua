class Admin::FlowerReceivesController < Admin::BaseController
   # before_action :set_receive, only: [ :update, :destroy]
  # before_action :set_project, only: [:index]
  before_action :set_project_apply, only: [:show, :edit, :new, :create, :update, :destroy]

  def new
    @receive = @apply.receive.new
  end

  def show
    @receive = @apply.receive
  end

  def edit
    @receive = @apply.receive
  end

  def create
    @receive = @apply.receive.new(receive_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.care_project.id, project_season_apply_id: receive_params[:owner_id], project_season_id: ProjectSeasonApply.find(receive_params[:owner_id]).season.id))
    respond_to do |format|
      if @receive.save
        format.html { redirect_to admin_flower_project_flower_receive_path(@apply), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @receive = @apply.receive
    respond_to do |format|
      if @receive.update(receive_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.care_project.id, project_season_apply_id: receive_params[:owner_id], project_season_id: ProjectSeasonApply.find(receive_params[:owner_id]).season.id))
        format.html { redirect_to admin_flower_project_flower_receive_path(@apply), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @receive = @apply.receive
    @receive.destroy
    respond_to do |format|
      format.html { redirect_to admin_flower_projects_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receive
      @receive = ReceiveFeedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receive_params
      params.require(:receive).permit!
    end

    def set_project
      @project = Project.find(Project.care_project.id)
    end

    def set_project_apply
      @apply = ProjectSeasonApply.find(params[:flower_project_id])
    end
end
