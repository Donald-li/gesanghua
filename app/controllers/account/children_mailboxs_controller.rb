class Account::ChildrenMailboxsController < Account::BaseController
  
  def index
    @child = ProjectSeasonApplyChild.find(params[:pair_id])
    scope = @child.continual_feedbacks.visible.sorted
    @feedbacks = scope.page(params[:page]).per(4)
    @feedbacks.each {|feedback| feedback.update(check: 'checked')}
  end

end
