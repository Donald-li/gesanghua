class Platform::School::Apply::ReadsController < Platform::School::BaseController
  before_action :set_apply, only: [:show]
  before_action :set_school

  def index
    scope = ProjectSeasonApply.where(project: Project.read_project, school: @school).sorted
    @applies = scope.page(params[:page]).per(8)
  end

  def show
  end

  def supplement

  end

  def new
    @apply = ProjectSeasonApply.new
  end

  def create
    season = ProjectSeason.find(apply_params[:season_id])
    @school = current.teacher.school
    if ProjectSeasonApply.allow_apply?(@school, season, Project.read_project)
      # @apply.form = params[:dynamic_form]
      @apply = ProjectSeasonApply.new(apply_params.merge(project: Project.read_project, school: @school, bookshelf_type: 'whole', contact_name: apply_params[:consignee], contact_phone: apply_params[:consignee_phone]))
      if @apply.save
        ProjectSeasonApplyBookshelf.where(id: params[:class_ids]).update(apply: @apply, season: season)
        @apply.attach_images(params[:image_ids])
        redirect_to platform_school_apply_reads_path, notice: '提交成功'
      else
        flash[:alert] = "保存失败，请重试"
        render :new
      end
    else
      redirect_to platform_school_apply_reads_path, notice: '您已经申请过本批次'
    end
  end

  private
  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

  def set_school
    @school = current_user.school
  end

  def apply_params
    params.require(:project_season_apply).permit!
  end

end
