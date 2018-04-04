class Admin::GoodsReceivesController < Admin::GoodsBaseController
   # before_action :set_receive, only: [ :update, :destroy]
  before_action :set_project_apply, only: [:show, :edit, :new, :create, :update, :destroy]

  def new
    @receive = @apply.receive_feedback.new
  end

  def show
    @receive = @apply.receive_feedback
  end

  def edit
    @receive = @apply.receive_feedback
  end

  def create
    @receive = @apply.receive_feedback.new(receive_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.care_project.id, project_season_apply_id: receive_params[:owner_id], project_season_id: ProjectSeasonApply.find(receive_params[:owner_id]).season.id))
    respond_to do |format|
      if @receive.save
        format.html { redirect_to admin_goods_project_goods_receive_path(@apply), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @receive = @apply.receive_feedback
    respond_to do |format|
      if @receive.update(receive_params.merge(owner_type: 'ProjectSeasonApply', project_id: Project.care_project.id, project_season_apply_id: receive_params[:owner_id], project_season_id: ProjectSeasonApply.find(receive_params[:owner_id]).season.id))
        format.html { redirect_to admin_goods_project_goods_receive_path(@apply), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @receive = @apply.receive_feedback
    @receive.destroy
    respond_to do |format|
      format.html { redirect_to admin_goods_projects_path, notice: '删除成功。' }
    end
  end

  private
    def set_receive
      @receive = ReceiveFeedback.find(params[:id])
    end

    def receive_params
      params.require(:receive).permit!
    end

    def set_project_apply
      @apply = ProjectSeasonApply.find(params[:goods_project_id])
    end
end
