class Account::ChildrenMailboxsController < Account::BaseController

  def index
    @child = ProjectSeasonApplyChild.find(params[:pair_id])
    scope = @child.children_feedback(current_user).visible.sorted
    @feedbacks = scope.page(params[:page]).per(4)
    @feedbacks.each {|feedback| feedback.update(check: 'checked')}
  end

end
