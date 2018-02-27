class Api::V1::Account::PairChildrenController < Api::V1::BaseController

  def index
    children = current_user.gsh_children.sorted.page(params[:page]).per(params[:per])
    api_success(data: {children: children.map { |r| r.summary_builder }, pagination: json_pagination(children)})
  end

  def feedback_list
    feedbacks = ProjectSeasonApplyChild.find(params[:child_id]).continuals.sorted.page(params[:page]).per(params[:per])
    api_success(data: {feedbacks: feedbacks.map{|feed| feed.detail_builder}, pagination: json_pagination(feedbacks)})
  end

end
