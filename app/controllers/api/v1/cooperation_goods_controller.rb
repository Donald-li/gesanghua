class Api::V1::CooperationGoodsController < Api::V1::BaseController
  before_action :set_project, only: [:index, :new,  :create]

  def index
    user = current_user
    # 校长或者教师的项目申请
    if user.teacher.present?
      if user.has_role?(:headmaster)
        applies = user.teacher.school.project_season_applies.where(project_id: @project.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.goods_apply_builder }, pagination: json_pagination(applies)})
      elsif user.has_role?(:teacher)
        applies = user.teacher.project_season_applies.where(project_id: @project.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.goods_apply_builder }, pagination: json_pagination(applies)})
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
    @seasons = @project.seasons.enable.all
    @school = current_user.teacher.school
    api_success(data: {form: @project.form, seasons: @seasons.map{|s| {name: s.name, value: s.id.to_s}}, school: @school.apply_builder})
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    @school = @apply.school
    api_success(data: {apply: @apply.goods_apply_builder,
      school: @school.apply_builder,
      images: @apply.images.map(&:summary_builder)})
  end

  def create
    user = current_user
    @school = user.teacher.school
    @apply = @project.applies.new
    @apply.project_season_id = params[:apply][:season][0]
    @apply.student_number = params[:apply][:student_number]
    @apply.describe = params[:apply][:describe]
    @apply.contact_name = params[:apply][:contact_name]
    @apply.contact_phone = params[:apply][:contact_phone]
    @apply.province = params[:apply][:location][0]
    @apply.city = params[:apply][:location][1]
    @apply.district = params[:apply][:location][2]
    @apply.address = params[:apply][:address]
    @apply.form = params[:dynamic_form]
    @apply.school_id = @school.id
    if @apply.save
      @apply.attach_images(params[:images])
      api_success(data: {result: true, project_id: @project.id})
    else
      api_success(data: {result: false})
    end
  end

  def update
    @apply = ProjectSeasonApply.find(params[:id])
    attributes = {
      project_season_id: params[:apply][:season][0],
      student_number: params[:apply][:student_number],
      describe: params[:apply][:describe],
      contact_name: params[:apply][:contact_name],
      contact_phone: params[:apply][:contact_phone],
      province: params[:apply][:location][0],
      city: params[:apply][:location][1],
      district: params[:apply][:location][2],
      address: params[:apply][:address],
      form: params[:dynamic_form]
    }
    if @apply.update(attributes)
      @apply.attach_images(params[:images])
      @apply.submit!
      api_success(data: {result: true, project_id: @apply.project_id})
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
  def set_project
    @project = Project.visible.find(params[:pid])
  end
end
