class Api::V1::CooperationCaresController < Api::V1::BaseController
  before_action :set_care, only: [:index, :create]

  def index
    user = current_user
    # 校长或者教师的项目申请
    if user.teacher.present?
      if user.has_role?(:headmaster)
        applies = user.teacher.school.project_season_applies.where(project_id: @care.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.care_apply_builder }, pagination: json_pagination(applies)})
      elsif user.has_role?(:teacher)
        applies = user.teacher.project_season_applies.where(project_id: @care.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.care_apply_builder }, pagination: json_pagination(applies)})
      else
      end
    else
      api_success(data: {applies: [], pagination: json_pagination([])})
    end
  end

  def new
    user = current_user
    @school = user.teacher.school
    @project = Project.care_project
    @seasons = @project.seasons.enable.all
    @school = current_user.teacher.school
    api_success(data: {form: @project.form, seasons: @seasons.map{|s| {name: s.name, value: s.id.to_s}}, school: @school.apply_builder})
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    @school = @apply.school
    api_success(data: {apply: @apply.care_apply_builder,
      school: @school.apply_builder,
      images: @apply.images.map(&:summary_builder)})
  end

  def create
    user = current_user
    @school = user.teacher.school
    @apply = @care.applies.new
    @apply.project_season_id = params[:care_apply][:season][0]
    @apply.student_number = params[:care_apply][:student_number]
    @apply.describe = params[:care_apply][:describe]
    @apply.contact_name = params[:care_apply][:contact_name]
    @apply.contact_phone = params[:care_apply][:contact_phone]
    @apply.province = params[:care_apply][:location][0]
    @apply.city = params[:care_apply][:location][1]
    @apply.district = params[:care_apply][:location][2]
    @apply.address = params[:care_apply][:address]
    @apply.form = params[:dynamic_form]
    @apply.school_id = @school.id
    if @apply.save
      @apply.attach_images(params[:images])
      api_success(data: {result: true})
    else
      api_success(data: {result: false})
    end
  end

  def update
    @apply = ProjectSeasonApply.find(params[:id])
    attributes = {
      project_season_id: params[:care_apply][:season][0],
      student_number: params[:care_apply][:student_number],
      describe: params[:care_apply][:describe],
      contact_name: params[:care_apply][:contact_name],
      contact_phone: params[:care_apply][:contact_phone],
      province: params[:care_apply][:location][0],
      city: params[:care_apply][:location][1],
      district: params[:care_apply][:location][2],
      address: params[:care_apply][:address],
      form: params[:dynamic_form]
    }
    if @apply.update(attributes)
      @apply.attach_images(params[:images])
      api_success(data: {result: true})
    else
      api_success(data: {result: false})
    end
  end

  private
  def set_care
    @care = Project.care_project
  end
end
