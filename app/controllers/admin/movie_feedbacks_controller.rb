class Admin::MovieFeedbacksController < Admin::BaseController
  before_action :set_continual, only: [:show, :edit, :update, :destroy, :recommend]
  # before_action :set_project, only: [:index]
  before_action :set_project_apply, only: [:index, :new, :create, :update, :destroy, :recommend]

  def index
    @continuals = @apply.continuals
    @search = @continuals.ransack(params[:q])
    scope = @search.result
    @continuals = scope.sorted.page(params[:page])
  end

  def new
    @continual = @apply.continuals.new
  end

  def edit
  end

  def create
    @continual = @apply.continuals.new(continual_params.merge(owner_type: 'ProjectSeasonApply', project_id: ProjectSeason.movie_project_id, project_season_apply_id: continual_params[:owner_id]))
    respond_to do |format|
      if @continual.save
        format.html { redirect_to admin_movie_school_movie_feedbacks_path(@apply), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @continual.update(continual_params.merge(owner_type: 'ProjectSeasonApply', project_id: ProjectSeason.movie_project_id, project_season_apply_id: continual_params[:owner_id]))
        format.html { redirect_to admin_movie_school_movie_feedbacks_path(@apply), notice: '修改成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @continual.destroy
    respond_to do |format|
      format.html { redirect_to admin_movie_school_movie_feedbacks_path(@apply), notice: '删除成功。' }
    end
  end

  def recommend
    @continual.recommend? ? @continual.normal! : @continual.recommend!
    redirect_to admin_movie_school_movie_feedbacks_path(@apply), notice:  @continual.recommend? ? '已推荐反馈' : '已取消推荐反馈'
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
      @project = Project.find(ProjectSeason.movie_project_id)
    end

    def set_project_apply
      @apply = ProjectSeasonApply.find(params[:movie_school_id])
    end
end
