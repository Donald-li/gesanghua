class Api::V1::Account::PairChildrenController < Api::V1::BaseController

  def index
    apply_child_ids = current_user.donate_records.visible.pluck(:project_season_apply_child_id)
    apply_child_ids = apply_child_ids.push(ProjectSeasonApplyChild.where(priority_id: current_user.id).pluck(:id)).flatten.uniq
    children = ProjectSeasonApplyChild.joins(:gsh_child).where(id: apply_child_ids).sorted.page(params[:page]).per(params[:per])
    children = children.where("project_season_apply_children.name like :q or gsh_children.gsh_no like :q", q: "%#{params[:keyword]}%") if params[:keyword].present?
    api_success(data: {children: children.map { |r| r.donate_children_builder(current_user) }, pagination: json_pagination(children)})
  end

  def feedback_list
    # 验证权限
    feedbacks = ContinualFeedback.where(project_season_apply_child_id: params[:child_id]).sorted.page(params[:page]).per(params[:per])
    api_success(data: {feedbacks: feedbacks.map{|f| f.detail_builder}, pagination: json_pagination(feedbacks)})
  end

end
