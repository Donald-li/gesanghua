class Platform::School::Apply::ReadsController < Platform::School::BaseController
  before_action :check_manage_limit # 是否可以管理该项目
  before_action :set_apply, only: [:show, :edit, :update, :edit_supplement, :update_supplement, :bookshelves, :supplements]
  before_action :set_school

  def index
    scope = ProjectSeasonApply.where(project: Project.read_project, school: @school).sorted
    @applies = scope.page(params[:page]).per(8)
  end

  def show
  end

  def new_supplement
    @apply = ProjectSeasonApply.new
  end

  def new
    @apply = ProjectSeasonApply.new
  end

  def edit
  end

  def edit_supplement
  end

  def create
    season = ProjectSeason.find(apply_params[:project_season_id])
    if ProjectSeasonApply.allow_apply?(@school, season, Project.read_project)
      # @apply.form = params[:dynamic_form]
      @apply = ProjectSeasonApply.new(apply_params.except(:class_ids).merge(project: Project.read_project, school: @school, bookshelf_type: 'whole', contact_name: apply_params[:consignee], contact_phone: apply_params[:consignee_phone]))
      if @apply.save
        ProjectSeasonApplyBookshelf.where(id: apply_params[:class_ids]).update(apply: @apply, season: season)
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

  def update
    if @apply.update(apply_params.except(:class_ids)) && @apply.submit!
      ProjectSeasonApplyBookshelf.where(id: apply_params[:class_ids]).update(apply: @apply, season: @apply.season, audit_state: 'submit')
      @apply.attach_images(params[:image_ids])
      redirect_to platform_school_apply_reads_path, notice: '提交成功'
    else
      flash[:alert] = "修改失败，请重试"
      render :edit
    end
  end

  def update_supplement
    @apply.update(apply_params.except(:supplement_ids))
    if @apply.save && @apply.submit!
      @apply.attach_images(params[:image_ids])
      @apply.supplement_ids = apply_params[:supplement_ids]
      redirect_to platform_school_apply_reads_path, notice: '提交成功'
    else
      flash[:alert] = "修改失败，请重试"
      render :new
    end
  end

  def create_supplement
    season = ProjectSeason.find(apply_params[:project_season_id])
    if ProjectSeasonApply.allow_apply?(@school, season, Project.read_project)
      @apply = ProjectSeasonApply.new(apply_params.except(:supplement_ids).merge(project: Project.read_project, bookshelf_type: 'supplement', school: @school, contact_name: apply_params[:consignee], contact_phone: apply_params[:consignee_phone]))
      if @apply.save
        @apply.attach_images(params[:image_ids])
        @apply.supplement_ids = apply_params[:supplement_ids]
        redirect_to platform_school_apply_reads_path, notice: '提交成功'
      else
        flash[:alert] = "保存失败，请重试"
        render :new
      end
    else
      redirect_to platform_school_apply_reads_path, notice: '您已经申请过本批次'
    end
  end

  def bookshelves
    @bookshelves = @apply.bookshelves
  end

  def supplements
    @supplements = @apply.supplements
  end

  private
  def check_manage_limit
    redirect_to root_path unless current_teacher.manage_projects.where(alias: 'read').exists?
  end

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
