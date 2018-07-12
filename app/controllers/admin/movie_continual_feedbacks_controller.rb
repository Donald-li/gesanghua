class Admin::MovieContinualFeedbacksController < Admin::BaseController
  before_action :set_continual, only: [:show, :edit, :update, :destroy, :recommend]
  before_action :set_project, only: [:index, :new, :create, :update, :destroy, :recommend]

  def index
    @continual_feedbacks = @project.continual_feedbacks
    @search = @continual_feedbacks.ransack(params[:q])
    scope = @search.result
    respond_to do |format|
      format.html { @continual_feedbacks = scope.page(params[:page]) }
      format.xlsx {
        @continual_feedbacks = scope.sorted.all
        OperateLog.create_export_excel(current_user, '反馈记录')
        response.headers['Content-Disposition'] = 'attachment; filename= "反馈记录" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
    @continual.update(check: 2)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @continual.update(continual_params)
        format.html { redirect_to referer_or(admin_movie_continual_feedbacks_path(@project)), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @continual.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_movie_continual_feedbacks_path(@project)), notice: '删除成功。' }
    end
  end

  def recommend
    @continual.recommend? ? @continual.normal! : @continual.recommend!
    redirect_to referer_or(admin_movie_continual_feedbacks_path(@project)), notice:  @continual.recommend? ? '已推荐反馈' : '已取消推荐反馈'
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
      @project = Project.movie_project
      auth_operate_project(@project)
    end
end
