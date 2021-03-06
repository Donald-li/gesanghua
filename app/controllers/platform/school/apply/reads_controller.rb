class Platform::School::Apply::ReadsController < Platform::School::BaseController
  before_action :set_apply, only: [:show, :edit, :update, :edit_supplement, :update_supplement, :bookshelves, :supplements]
  before_action :set_school
  before_action :set_project

  def index
    scope = ProjectSeasonApply.where(project: @project, school: @school).sorted
    @applies = scope.page(params[:page]).per(8)
  end

  def show
  end

  def new_supplement
    @apply = @project.applies.new
  end

  def new
    @apply = @project.applies.new
  end

  def edit
  end

  def edit_supplement
  end

  def create
    season = ProjectSeason.find(apply_params[:project_season_id])
    if ProjectSeasonApply.allow_apply?(@school, season, @project)
      # @apply.form = params[:dynamic_form]
      @apply = ProjectSeasonApply.new(apply_params.except(:class_ids).merge(project: @project, school: @school, bookshelf_type: 'whole'))
      if @apply.save
        ProjectSeasonApplyBookshelf.where(id: apply_params[:class_ids]).update(apply: @apply, season: season)
        @apply.attach_images(params[:image_ids])
        redirect_to platform_school_apply_reads_path, notice: '提交成功'
      else
        flash[:alert] = "保存失败，请重试"
        render :new
      end
    else
      flash[:alert] = "您已经申请过本批次"
      render :new
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
      BookshelfSupplement.where(id: apply_params[:supplement_ids]).update(apply: @apply, audit_state: 'submit')
      redirect_to platform_school_apply_reads_path, notice: '提交成功'
    else
      flash[:alert] = "修改失败，请重试"
      render :new
    end
  end

  def create_supplement
    season = ProjectSeason.find(apply_params[:project_season_id])
    if ProjectSeasonApply.allow_apply?(@school, season, @project)
      if apply_params[:supplement_ids].length > 0
        @apply = ProjectSeasonApply.new(apply_params.except(:supplement_ids).merge(project: @project, bookshelf_type: 'supplement', school: @school))
        if @apply.save
          @apply.attach_images(params[:image_ids])
          @apply.supplement_ids = apply_params[:supplement_ids]
          redirect_to platform_school_apply_reads_path, notice: '提交成功'
        else
          flash[:alert] = "保存失败，请重试"
          render :new
        end
      else
        flash[:alert] = "没有可补书班级"
        render :new
      end
    else
      flash[:alert] = "您已经申请过本批次"
      render :new
    end
  end

  def bookshelves
    @bookshelves = @apply.bookshelves
  end

  def supplements
    @supplements = @apply.supplements
  end

  private

  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

  def set_school
    @school = current_user.teacher.school
  end

  def set_project
    @project = Project.read_project
  end

  def apply_params
    params.require(:project_season_apply).permit!
  end

end
