class Account::PairsController < Account::BaseController

  def index
    scope = ProjectSeasonApplyChild.where(id: current_user.gsh_child_grants.pluck(:gsh_child_id)).sorted
    @children = scope.page(params[:page]).per(4)
  end

end
