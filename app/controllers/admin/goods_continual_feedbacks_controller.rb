class Admin::GoodsContinualFeedbacksController < Admin::GoodsBaseController
  before_action :set_continual, only: [:show, :edit, :update, :destroy, :recommend]

  def index
    @continual_feedbacks = ContinualFeedback.where(project_id: @current_project.id)
    @search = @continual_feedbacks.ransack(params[:q])
    scope = @search.result
    respond_to do |format|
      format.html { @continual_feedbacks = scope.page(params[:page]) }
      format.xlsx {
        @continual_feedbacks = scope.sorted.all
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
        format.html { redirect_to admin_goods_continual_feedbacks_path(@current_project), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @continual.destroy
    respond_to do |format|
      format.html { redirect_to admin_goods_continual_feedbacks_path(@current_project), notice: '删除成功。' }
    end
  end

  def recommend
    @continual.recommend? ? @continual.normal! : @continual.recommend!
    redirect_to admin_goods_continual_feedbacks_path(@project), notice:  @continual.recommend? ? '已推荐反馈' : '已取消推荐反馈'
  end

  private
    def set_continual
      @continual = ContinualFeedback.find(params[:id])
    end

    def continual_params
      params.require(:continual).permit!
    end
end
