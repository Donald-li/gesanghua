class Admin::TeamsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_team, only: [:show, :destroy, :edit, :update, :dismiss, :donate_records]

  def index
    @search = Team.sorted.ransack(params[:q])
    scope = @search.result
    @teams = scope.page(params[:page])
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to referer_or(admin_teams_path), notice: '修改成功'
    else
      flash[:notice] = '修改成功'
      render :edit
    end
  end

  def dismiss
    store_referer
    @team.dismiss! && @team.users.update(team_id: nil)
    redirect_to referer_or(admin_teams_path), notice: '解散成功'
  end

  def donate_records
    @search = @team.donate_records.ransack(params[:q])
    scope = @search.result
    @donate_records = scope.page(params[:page])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit!
  end
end
