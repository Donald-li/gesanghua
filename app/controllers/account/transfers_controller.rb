class Account::TransfersController < Account::BaseController
  before_action :set_team, only: [:index]

  def index
    @team_creater = @team.creater if @team.manager != @team.creater
    @team_members = @team.users.where.not(id: @team.manager.id).sorted
  end

  private
  def set_team
    @team = Team.find(params[:team_id])
  end

end
