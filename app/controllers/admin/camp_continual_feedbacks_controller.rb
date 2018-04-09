class Admin::CampContinualFeedbacksController < Admin::BaseController
  before_action :set_continual, only: [:show, :edit, :update, :destroy, :recommend]
  before_action :set_project, only: [:index, :new, :create, :update, :destroy, :recommend]

  def index
    @continual_feedbacks = @project.continual_feedbacks
    @search = @continual_feedbacks.ransack(params[:q])
    scope = @search.result
    @continual_feedbacks = scope.sorted.page(params[:page])
  end

  def show
    @continual.update(check: 2)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @continual.update(continual_params)
        format.html { redirect_to admin_camp_continual_feedbacks_path(@project), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @continual.destroy
    respond_to do |format|
      format.html { redirect_to admin_camp_continual_feedbacks_path(@project), notice: '删除成功。' }
    end
  end

  def recommend
    @continual.recommend? ? @continual.normal! : @continual.recommend!
    redirect_to admin_camp_continual_feedbacks_path(@project), notice:  @continual.recommend? ? '已推荐反馈' : '已取消推荐反馈'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_continual
      @continual = ContinualFeedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def continual_params
      params.require(:continual).permit!
    end

    def set_project
      @project = Project.find(Project.camp_project.id)
    end
end
