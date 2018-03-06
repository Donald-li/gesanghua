class Api::V1::Account::MyReadsController < Api::V1::BaseController

  def index
    # donates =  DonateRecord.joins(:bookshelf).where(user_id: 2).where("project_season_apply_bookshelves.target_amount = donate_records.amount")
    user_id = 2
    scope = ProjectSeasonApplyBookshelf.joins(:donates).where("donate_records.amount = project_season_apply_bookshelves.target_amount").where("donate_records.user_id = ? and donate_records.pay_state = ?", user_id, 2)
    bookshelves = scope.page(params[:page]).per(params[:per])
    api_success(data: {bookshelves: bookshelves.map { |r| r.summary_builder }, pagination: json_pagination(bookshelves)})
  end

end
