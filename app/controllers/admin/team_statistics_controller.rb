class Admin::TeamStatisticsController < Admin::BaseController
  before_action :auth_manage_operation

  def show
    @teams = Team.sorted.page(params[:page])
    @income_statistics = IncomeRecord.all
    @income_statistics = @income_statistics.where("income_time > ?", params[:time_start]) if params[:time_start].present?
    @income_statistics = @income_statistics.where("income_time < ?", params[:time_end].end_of_day) if params[:time_end].present?
    @income_statistics = @income_statistics.where("income_time > ?", Time.mktime(params[:fix_year])) if params[:fix_year].present?
    @income_statistics = @income_statistics.select("team_id, sum(amount) as amount").group(:team_id)

    @promote_statistics = IncomeRecord.where.not(promoter_id: nil)
    @promote_statistics = @promote_statistics.where("income_time > ?", params[:time_start]) if params[:time_start].present?
    @promote_statistics = @promote_statistics.where("income_time < ?", params[:time_end].end_of_day) if params[:time_end].present?
    @promote_statistics = @promote_statistics.where("income_time > ?", Time.mktime(params[:fix_year])) if params[:fix_year].present?
    @promote_statistics = @promote_statistics.select("team_id, sum(amount) as amount").group(:team_id)
  end

end