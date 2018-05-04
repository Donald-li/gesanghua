class Api::V1::CooperationMoviesController < Api::V1::BaseController
  before_action :set_movie, only: [:index, :create]

  def index
    user = current_user
    # 校长或者教师的项目申请
    if user.teacher.present?
      if user.has_role?(:headmaster)
        applies = user.teacher.school.project_season_applies.joins(:project).includes(:season).where(project_id: @movie.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map {|r| r.movie_apply_builder}, pagination: json_pagination(applies)})
      elsif user.has_role?(:teacher)
        applies = user.teacher.project_season_applies.joins(:project).includes(:season).where(project_id: @movie.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map {|r| r.movie_apply_builder}, pagination: json_pagination(applies)})
      else
        api_success(data: {applies: [], pagination: json_pagination([])})
      end
    else
      api_success(data: {applies: [], pagination: json_pagination([])})
    end
  end

  def new
    user = current_user
    @school = user.teacher.school
    @project = Project.movie_project
    @seasons = @project.seasons.enable.all
    @school = current_user.teacher.school
    api_success(data: {form: @project.form, seasons: @seasons.map {|s| {name: s.name, value: s.id.to_s}}, school: @school.apply_builder})
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    @school = @apply.school
    api_success(data: {apply: @apply.movie_apply_builder,
                       school: @school.apply_builder,
                       images: @apply.images.map(&:summary_builder)})
  end

  def create
    user = current_user
    @school = user.teacher.school
    season = ProjectSeason.find(params[:movie_apply][:season][0])
    if ProjectSeasonApply.allow_apply?(@school, season, @movie)
      @apply = @movie.applies.new
      @apply.project_season_id = params[:movie_apply][:season][0]
      @apply.student_number = params[:movie_apply][:student_number]
      @apply.class_number = params[:movie_apply][:class_number]
      @apply.contact_name = params[:movie_apply][:contact_name]
      @apply.contact_phone = params[:movie_apply][:contact_phone]
      @apply.form = params[:dynamic_form]
      @apply.applicant_id = params[:applicant]
      @apply.school_id = @school.id
      if @apply.save
        api_success(data: {result: true})
      else
        api_success(data: {result: false})
      end
    else
      api_success(data: {result: false}, message: '您无法申请本批次')
    end
  end

  def update
    @apply = ProjectSeasonApply.find(params[:id])
    attributes = {
        project_season_id: params[:movie_apply][:season][0],
        student_number: params[:movie_apply][:student_number],
        class_number: params[:movie_apply][:class_number],
        contact_name: params[:movie_apply][:contact_name],
        contact_phone: params[:movie_apply][:contact_phone],
        form: params[:dynamic_form]
    }
    if @apply.update(attributes)
      @apply.update(audit_state: 'submit')
      api_success(data: {result: true})
    else
      api_success(data: {result: false})
    end
  end

  private
  def set_movie
    @movie = Project.movie_project
  end
end
