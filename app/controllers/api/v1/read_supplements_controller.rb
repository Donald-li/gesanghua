class Api::V1::ReadSupplementsController < Api::V1::BaseController
  before_action :set_project, only: [:create]
  before_action :set_apply, only: [:show, :update]

  def create
    user = current_user
    @school = user.teacher.school
    @apply = ProjectSeasonApply.new
    @apply.bookshelf_type = 'supplement'
    @apply.school_id = @school.id
    @apply.contact_name = params[:receive_info][:contact_name]
    @apply.contact_phone = params[:receive_info][:contact_phone]
    @apply.province = params[:receive_info][:location][0] if params[:receive_info][:location].present?
    @apply.city = params[:receive_info][:location][1] if params[:receive_info][:location].present?
    @apply.district = params[:receive_info][:location][2] if params[:receive_info][:location].present?
    @apply.address = params[:receive_info][:address]
    @apply.project_season_id = params[:submit_form][:season][0] if params[:submit_form][:season].present?
    @apply.project = @project
    @apply.describe = params[:submit_form][:describe]
    if @apply.save
      @apply.attach_images(params[:images])
      @apply.supplement_ids = params[:class_list]
      api_success(data: {result: true})
    else
      api_success(data: {result: false})
    end
  end

  def show
    user = current_user
    @school = user.teacher.school
    api_success(data: {school: @school.name,
      submit_form: @apply.read_apply_submit_form_summary_builder,
      images: @apply.images.map(&:summary_builder),
      class_list: @apply.supplements.map{|s| s.summary_builder},
      receive_info: @apply.read_supply_receive_info_summary_builder})
  end

  def update
    @apply.contact_name = params[:receive_info][:contact_name]
    @apply.contact_phone = params[:receive_info][:contact_phone]
    @apply.province = params[:receive_info][:location][0] if params[:receive_info][:location].present?
    @apply.city = params[:receive_info][:location][1] if params[:receive_info][:location].present?
    @apply.district = params[:receive_info][:location][2] if params[:receive_info][:location].present?
    @apply.address = params[:receive_info][:address]
    @apply.project_season_id = params[:submit_form][:season][0] if params[:submit_form][:season].present?
    @apply.describe = params[:submit_form][:describe]
    if @apply.save
      @apply.attach_images(params[:images])
      @apply.supplement_ids = params[:class_list]
      api_success(data: {result: true})
    else
      api_success(data: {result: false})
    end
  end

  def class_list
    @apply = ProjectSeasonApply.find(params[:id])
    @supplements = @apply.supplements.pass.sorted
    api_success(data: @supplements.map { |s| s.class_list_summary_builder })
  end

  def can_apply
    @school = current_user.teacher.school
    season = ProjectSeason.find(params[:season_id])
    if ProjectSeasonApply.allow_apply?(@school, season)
      api_success(data: {result: true}, message: '')
    else
      api_success(data: {result: false}, message: '您无法申请本批次')
    end
  end

  def show_logistic
    @supplement = BookshelfSupplement.find(params[:id])
    @logistic = @supplement.logistic
    api_success(data: @logistic.qurey_result)
  end

  private
  def set_project
    @project = Project.book_supply_project
  end

  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

end
