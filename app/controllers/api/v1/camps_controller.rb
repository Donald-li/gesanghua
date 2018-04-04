class Api::V1::CampsController < Api::V1::BaseController
  before_action :set_project, only: [:show]
  before_action :set_apply, only: [:apply_camp, :member, :feedback, :complaint]

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def get_address_list
    api_success(data: Camp.address_group)
  end

  def applies_list
    @camp_applies = ProjectSeasonApply.where(project: Project.camp_project).raise_project.show.camp_raising.sorted
    total = @camp_applies.count
    @camp_applies = @camp_applies.where(camp_id: Camp.where(city: params[:city]).pluck(:id)) if params[:city].present?
    @camp_applies = @camp_applies.where(camp_id: Camp.where(district: params[:district]).pluck(:id)) if params[:district].present?
    @camp_applies = @camp_applies.page(params[:page]).per(params[:per])
    api_success(data: {camp_list: @camp_applies.collect{|item| item.summary_builder}, total: total, pagination: json_pagination(@camp_applies)})
  end

  def apply_camp
    api_success(data: @apply.detail_builder)
  end

  def member
    @member = @apply.camp_members.joins(:apply_camp).where("project_season_apply_camps.execute_state = ?", 3).pass.sorted.page(params[:page]).per(7)
    api_success(data: {member: @member.map {|m| m.summary_builder}, pagination: json_pagination(@member)})
  end

  def feedback
    @feedbacks = @apply.continual_feedbacks.show.recommend.sorted.page(params[:page]).per(7)
    api_success(data: {feedbacks: @feedbacks.map {|m| m.detail_builder}, pagination: json_pagination(@feedbacks)})
  end

  def complaint
    api_error(message: '无效页面') && return unless @apply
    complaint = Complaint.find_by(contact_phone: complaint_params[:contact_phone], owner: @apply)
    if complaint.present?
      api_success(message: '您已经提交过举报信息', data: false)
    else
      @complaint = Complaint.new(complaint_params)
      @complaint.owner = @apply
      if @complaint.save
        @complaint.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        api_success(message: '举报成功，管理员会尽快处理', data: true)
      else
        api_success(message: '提交失败，请重试', data: false)
      end
    end
  end

  private
  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

  def set_project
    @project = Project.camp_project
  end

  def complaint_params
    params.require(:complaint).permit!
  end

end
