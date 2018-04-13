class Account::ChildrenMailboxsController < Account::BaseController
  
  def index
    @child = ProjectSeasonApplyChild.find(params[:pair_id])
    scope = ContinualFeedback.where(gsh_child_grant_id: @child.gsh_child_grants.where(user_id: current_user.id).pluck(:id)).sorted
    @feedbacks = scope.page(params[:page]).per(4)
  end

end
