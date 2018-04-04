class Camp::ExecuteFeedbacksController < Camp::BaseController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy, :recommend]
  before_action :set_project

  def index
    @feedbacks = @project.continual_feedbacks
    @search = @feedbacks.ransack(params[:q])
    scope = @search.result
    @feedbacks = scope.sorted.page(params[:page])
  end

  def show
  end

  def new
    @feedback = ContinualFeedback.new
  end

  def create
    @feedback = ContinualFeedback.new(owner: @project, content: execute_params[:content], user_id: execute_params[:user_id], project: Project.camp_project)
    respond_to do |format|
      if @feedback.save
        @feedback.attach_images(params[:image_ids])
        format.html { redirect_to camp_project_execute_feedbacks_path(@project), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @feedback.update(execute_params)
        @feedback.attach_images(params[:image_ids])
        format.html { redirect_to camp_project_execute_feedbacks_path(@project), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to camp_project_execute_feedbacks_path(@project), notice: '删除成功。' }
    end
  end

  def recommend
    @feedback.recommend? ? @feedback.normal! : @feedback.recommend!
    redirect_to camp_project_execute_feedbacks_path(@project), notice:  @feedback.recommend? ? '已推荐反馈' : '已取消推荐反馈'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = ContinualFeedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def execute_params
      params.require(:continual_feedback).permit!
    end

    def set_project
      @project = ProjectSeasonApply.find(params[:project_id])
    end
end
