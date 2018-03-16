class Api::V1::CooperationReadsController < Api::V1::BaseController
  before_action :set_read, only: [:index, :create]

  def index
    user = current_user
    # 校长或者教师的项目申请
    if user.teacher.present?
      if user.has_role?(:headmaster)
        applies = user.teacher.school.project_season_applies.where(project_id: @read.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.read_apply_builder }, pagination: json_pagination(applies)})
      elsif user.has_role?(:teacher)
        applies = user.teacher.project_season_applies.where(project_id: @read.id).sorted.page(params[:page])
        api_success(data: {applies: applies.map { |r| r.read_apply_builder }, pagination: json_pagination(applies)})
      else
      end
    else
      api_success(data: {applies: [], pagination: json_pagination([])})
    end
  end

  def new
    user = current_user
    @school = user.teacher.school
    @project = Project.read_project
    @seasons = @project.seasons.enable.all
    @school = current_user.teacher.school
    @class = @school.bookshelves.done
    api_success(data: {form: @project.form, seasons: @seasons.map{|s| {name: s.name, value: s.id.to_s}}, school: @school.apply_builder, class_list: @class.map { |c| {name: c.classname, value: c.id.to_s} }})
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    api_success(data: {apply: @apply.read_apply_builder,
      submit_form: @apply.read_apply_submit_form_summary_builder,
      images: @apply.images.map(&:summary_builder),
      class_list: @apply.bookshelves.map{|b| b.class_summary_builder}})
  end

  def create
    user = current_user
    @school = user.teacher.school
    @apply = @read.applies.new
    @apply.bookshelf_type = 1
    @apply.project_season_id = params[:read_apply][:season][0]
    @apply.class_number = params[:read_apply][:class_number]
    @apply.student_number = params[:read_apply][:student_number]
    @apply.contact_name = params[:read_apply][:contact_name]
    @apply.contact_phone = params[:read_apply][:contact_phone]
    @apply.province = params[:read_apply][:location][0]
    @apply.city = params[:read_apply][:location][1]
    @apply.district = params[:read_apply][:location][2]
    @apply.address = params[:read_apply][:address]
    @apply.bookshelf_ids = params[:class_ids]
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
      project_season_id: params[:read_apply][:season][0],
      class_number: params[:read_apply][:class_number],
      student_number: params[:read_apply][:student_number],
      contact_name: params[:read_apply][:contact_name],
      contact_phone: params[:read_apply][:contact_phone],
      province: params[:read_apply][:location][0],
      city: params[:read_apply][:location][1],
      district: params[:read_apply][:location][2],
      address: params[:read_apply][:address],
      form: params[:dynamic_form],
      class_ids: params[:class_ids]
    }
    if @apply.update(attributes)
      @apply.attach_images(params[:images])
      api_success(data: {result: true})
    else
      api_success(data: {result: false})
    end
  end

  private
  def set_read
    @read = Project.read_project
  end
end
