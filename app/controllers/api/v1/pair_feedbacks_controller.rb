class Api::V1::PairFeedbacksController < Api::V1::BaseController

  def find_child
    @child = GshChild.find_by(id_card: params[:id_card])
    if @child.present?
      api_success(data: {seach_values: @child.pair_feedback_builder, result: true})
    else
      api_success(data: {result: false})
    end
  end

  def create_pair_feedback
    @project = Project.pair_project
    @user = current_user
    @child = GshChild.find(params[:child_id])
    @grant = GshChildGrant.find(params[:grant_id])
    @feedback = ContinualFeedback.new(content: params[:content], owner: @grant, project: Project.pair_project, user: @user, gsh_child_grant: @grant, season: @grant.season, apply: @grant.apply, child: @grant.apply_child)
    if @feedback.save
      @feedback.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
      api_success(message: '您的反馈已提交')
    else
      api_success(message: '提交失败，请重试')
    end
  end

  def index
    # feedbacks = ProjectSeasonApplyChild.find(params[:child_id]).continual_feedbacks.sorted.page(params[:page]).per(params[:per])
    feedbacks = GshChild.find(params[:child_id]).continual_feedbacks.sorted.page(params[:page]).per(params[:per])
    api_success(data: {feedbacks: feedbacks.map{|f| f.detail_builder}, pagination: json_pagination(feedbacks)})
  end

end
