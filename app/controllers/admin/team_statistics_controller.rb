class Admin::TeamStatisticsController < Admin::BaseController
  before_action :auth_manage_operation

  def show
    @team_statistics = Team.sorted.page(params[:page])
  end

end