class Platform::School::Apply::MovieCaresController < Platform::School::BaseController
  before_action :set_apply, only: [:show, :edit, :update]
  before_action :set_school

  def index
    scope = ProjectSeasonApply.where(project: Project.movie_care_project, school: @school).sorted
    @applies = scope.page(params[:page]).per(8)
  end

  def show
  end

  def new
    @apply = ProjectSeasonApply.new
  end

  def create
    season = ProjectSeason.find(apply_params[:project_season_id])
    if ProjectSeasonApply.allow_apply?(@school, season, Project.read_project)
      @apply = ProjectSeasonApply.new(apply_params.merge(project: Project.movie_care_project, school: @school))
      if @apply.save
        @apply.attach_images(params[:image_ids])
        redirect_to platform_school_apply_movie_cares_path, notice: '提交成功'
      else
        flash[:alert] = "保存失败，请重试"
        render :new
      end
    else
      redirect_to platform_school_apply_reads_path, notice: '您已经申请过本批次'
    end
  end

  def edit
  end

  def update
    if @apply.update(apply_params.merge(audit_state: 'submit'))
      @apply.attach_images(params[:image_ids])
      redirect_to platform_school_apply_movie_cares_path, notice: '提交成功'
    else
      flash[:alert] = "修改失败，请重试"
      render :edit
    end
  end

  private

  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

  def set_school
    @school = current_user.teacher.school
  end

  def apply_params
    params.require(:project_season_apply).permit!
  end

end
