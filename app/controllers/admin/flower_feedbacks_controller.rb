class Admin::FlowerFeedbacksController < Admin::BaseController
  before_action :set_continual, only: [:show, :destroy]
  # before_action :set_project, only: [:index]
  before_action :set_project_apply, only: [:index, :new, :create, :destroy]

  def index
    @continuals = @apply.continuals
    @search = @continuals.ransack(params[:q])
    scope = @search.result
    @continuals = scope.sorted.page(params[:page])
  end

  def new
    @continual = Continual.new
  end

  def edit
  end

  def create
    @continual = Continual.new(continual_params.merge(owner_type: 'ProjectSeasonApply'))
    respond_to do |format|
      if @continual.save
        format.html { redirect_to admin_flower_project_flower_feedbacks_path(@apply), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
  end

  def destroy
    @continual.destroy
    respond_to do |format|
      format.html { redirect_to admin_flower_project_flower_feedbacks_path(@apply), notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_continual
      @continual = Continual.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def continual_params
      params.require(:continual).permit!
    end

    def set_project
      @project = Project.find(ProjectSeason.flower_project_id)
    end

    def set_project_apply
      @apply = ProjectSeasonApply.find(params[:flower_project_id])
    end
end
