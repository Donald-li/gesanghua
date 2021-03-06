class Api::V1::Account::MyReadsController < Api::V1::BaseController

  def index
    # donates =  DonateRecord.joins(:bookshelf).where(user_id: 2).where("project_season_apply_bookshelves.target_amount = donate_records.amount")
    user_id = current_user.id
    scope = ProjectSeasonApplyBookshelf.joins(:apply).joins("inner join donate_records on donate_records.owner_type='ProjectSeasonApplyBookshelf' and donate_records.owner_id=project_season_apply_bookshelves.id").where("donate_records.amount = project_season_apply_bookshelves.target_amount").where("donate_records.agent_id = ? ", user_id)
    scope = scope.where("project_season_apply_bookshelves.title like :q or project_season_applies.name like :q or bookshelf_no like :q", q: "%#{params[:keyword]}%") if params[:keyword].present?
    bookshelves = scope.sorted.page(params[:page]).per(params[:per])
    api_success(data: {bookshelves: bookshelves.map { |r| r.summary_builder }, pagination: json_pagination(bookshelves)})
  end

end
