class Account::PairsController < Account::BaseController

  def index
    apply_child_ids = current_user.donate_records.visible.pluck(:project_season_apply_child_id)
    scope = ProjectSeasonApplyChild.where(id: apply_child_ids).sorted
    @children = scope.page(params[:page]).per(4)
  end

end
