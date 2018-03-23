class Api::V1::CooperationRadiosController < Api::V1::BaseController
  before_action :set_radio, only: [:index, :create]

  def index
    user = current_user
    # 校长或者教师的项目申请
    if user.teacher.present?
      if user.has_role?(:headmaster)
        applies = user.teacher.school.project_season_applies.where(project_id: @radio.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.radio_apply_builder }, pagination: json_pagination(applies)})
      elsif user.has_role?(:teacher)
        applies = user.teacher.project_season_applies.where(project_id: @radio.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.radio_apply_builder }, pagination: json_pagination(applies)})
      else
      end
    else
      api_success(data: {applies: [], pagination: json_pagination([])})
    end
  end

  def new
    user = current_user
    @school = user.teacher.school
    @project = Project.radio_project
    @seasons = @project.seasons.enable.all
    @school = current_user.teacher.school
    api_success(data: {form: @project.form, seasons: @seasons.map{|s| {name: s.name, value: s.id.to_s}}, school: @school.apply_builder})
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    @school = @apply.school
    api_success(data: {apply: @apply.radio_apply_builder,
      school: @school.apply_builder,
      images: @apply.images.map(&:summary_builder)})
  end

  def create
    user = current_user
    @school = user.teacher.school
    @apply = @radio.applies.new
    @apply.project_season_id = params[:radio_apply][:season][0]
    @apply.student_number = params[:radio_apply][:student_number]
    @apply.describe = params[:radio_apply][:describe]
    @apply.contact_name = params[:radio_apply][:contact_name]
    @apply.contact_phone = params[:radio_apply][:contact_phone]
    @apply.province = params[:radio_apply][:location][0]
    @apply.city = params[:radio_apply][:location][1]
    @apply.district = params[:radio_apply][:location][2]
    @apply.address = params[:radio_apply][:address]
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
      project_season_id: params[:radio_apply][:season][0],
      student_number: params[:radio_apply][:student_number],
      describe: params[:radio_apply][:describe],
      contact_name: params[:radio_apply][:contact_name],
      contact_phone: params[:radio_apply][:contact_phone],
      province: params[:radio_apply][:location][0],
      city: params[:radio_apply][:location][1],
      district: params[:radio_apply][:location][2],
      address: params[:radio_apply][:address],
      form: params[:dynamic_form]
    }
    if @apply.update(attributes)
      @apply.attach_images(params[:images])
      api_success(data: {result: true})
    else
      api_success(data: {result: false})
    end
  end

  def show_logistic
    @apply = ProjectSeasonApply.find(params[:id])
    @logistic = @apply.logistic
    api_success(data: @logistic.qurey_result)
  end

  private
  def set_radio
    @radio = Project.radio_project
  end
end
