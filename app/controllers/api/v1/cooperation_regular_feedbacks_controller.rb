class Api::V1::CooperationRegularFeedbacksController < Api::V1::BaseController
  before_action :set_project, only: [:create, :feedback_list, :qrcode, :get_info]

  def index
    projects = Project.open_feedback.sorted
    api_success(data: {projects: projects.map{|p| p.summary_builder}})
  end

  def create
    feedback = ContinualFeedback.new(owner: @project, school: current_user.school, content: params[:content], user: current_user, project: @project)
    if feedback.save
      feedback.attach_images(params[:images].pluck(:id)) if params[:images].present?
      api_success(data: true, message: '你的反馈已提交~')
    else
      api_success(data: false, message: feedback.errors.full_messages.first)
    end
  end

  def feedback_list
    feedbacks =  @project.continual_feedbacks.sorted.page(params[:page]).per(params[:per])
    api_success(data: {feedbacks: feedbacks.map{|f| f.detail_builder}, pagination: json_pagination(feedbacks)})
  end

  def qrcode
    url = "http://#{Settings.app_host}/form/link-to-visit?type=regular_feedback&project_id=#{@project.id}"
    api_success(data: {qrcode_url: url})
  end

  def get_info
    api_success(data: {school_name: current_user.teacher.try(:school).try(:name), project_name: @project.name})
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end
end
