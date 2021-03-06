class Api::V1::PairFeedbacksController < Api::V1::BaseController

  def find_child
    scope = GshChild.find_by(id_card: params[:id_card]) if params[:id_card].present? && params[:id_card] !=(nil || '')
    scope = GshChild.find_by(gsh_no: params[:gsh_no]) if params[:gsh_no].present? && params[:gsh_no] !=(nil || '')
    @child = scope
    if @child.present? && (params[:id_card] && params[:id_card] !=(nil || '') || (params[:gsh_no] && params[:name] && @child.name == params[:name]))
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
    @feedback = ContinualFeedback.new(content: params[:content], owner: @child, project: Project.pair_project, user: @user, gsh_child_grant: @grant, season: @grant.season, apply: @grant.apply, child: @grant.apply_child)
    if @feedback.save
      @feedback.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
      Notification.create(
          kind: 'child_feedback',
          owner: @grant,
          user_id: @grant.user_id,
          title: "#反馈通知# 有新的孩子邮件",
          content: "你捐助的 #{@grant.apply_child.try(:name)} 提交了新反馈，点击查看详情",
          url: "#{Settings.m_root_url}/account/child-mailbox?id=#{@grant.apply_child.try(:id)}"
      )
      api_success(message: '您的反馈已提交')
    else
      api_success(message: '提交失败，请重试')
    end
  end

  def index
    # feedbacks = ProjectSeasonApplyChild.find(params[:child_id]).continual_feedbacks.sorted.page(params[:page]).per(params[:per])
    # user_ids = [current_user.id]
    # user_ids += current_user.offline_users.unactived.try(:ids)
    # grant_ids = GshChildGrant.where(user_id: user_ids).ids
    # scope = ContinualFeedback.where(gsh_child_grant_id: grant_ids, owner_id: params[:child_id]).sorted
    # feedbacks = scope.page(params[:page]).per(params[:per])
    feedbacks = GshChild.find(params[:child_id]).continual_feedbacks.sorted.page(params[:page]).per(params[:per])
    api_success(data: {feedbacks: feedbacks.map{|f| f.detail_builder}, pagination: json_pagination(feedbacks)})
  end

end
