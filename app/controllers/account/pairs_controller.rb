class Account::PairsController < Account::BaseController

  def index
    apply_child_ids = current_user.donate_records.visible.pluck(:project_season_apply_child_id)
    apply_child_ids = apply_child_ids.push(ProjectSeasonApplyChild.where(priority_id: current_user.id).pluck(:id)).flatten.uniq
    scope = ProjectSeasonApplyChild.where(id: apply_child_ids).sorted
    @children = scope.page(params[:page]).per(4)
  end

end
