class Account::BookshelvesController < Account::BaseController

  def index
    user_id = current_user.id
    scope = ProjectSeasonApplyBookshelf.joins("inner join donate_records on donate_records.owner_type='ProjectSeasonApplyBookshelf' and donate_records.owner_id=project_season_apply_bookshelves.id").where("donate_records.amount = project_season_apply_bookshelves.target_amount").where("donate_records.agent_id = ? ", user_id)
    @bookshelves = scope.page(params[:page]).per(4)
  end

end
