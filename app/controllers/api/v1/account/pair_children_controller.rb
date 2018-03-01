class Api::V1::Account::PairChildrenController < Api::V1::BaseController

  def index
    children = current_user.children.sorted.page(params[:page]).per(params[:per])
    api_success(data: {children: children.map { |r| r.donate_children_builder }, pagination: json_pagination(children)})
  end

  def feedback_list
    feedbacks = ContinualFeedback.where(gsh_child_grant_id: ProjectSeasonApplyChild.find(params[:child_id]).gsh_child_grants.where(donate_user_id: current_user.id).pluck(:id)).sorted.page(params[:page]).per(params[:per])
    api_success(data: {feedbacks: feedbacks.map{|f| f.detail_builder}, pagination: json_pagination(feedbacks)})
  end

end
