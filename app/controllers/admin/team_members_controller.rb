class Admin::TeamMembersController < Admin::BaseController
  before_action :set_team
  before_action :set_member, only: [:destroy, :update]

  def index
    @search = @team.users.sorted.ransack(params[:q])
    scope = @search.result
    @members = scope.page(params[:page])
  end

  def update
    if @team.update(manage_id: @member.id)
      redirect_to referer_or(admin_team_team_members_path(@team)), notice: '操作成功'
    else
      redirect_to referer_or(admin_team_team_members_path(@team)), notice: '操作失败'
    end
  end

  def destroy
    if @member.update(team_id: nil)
      redirect_to referer_or(admin_team_team_members_path(@team)), notice: '操作成功'
    else
      redirect_to referer_or(admin_team_team_members_path(@team)), notice: '操作失败'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_member
    @member = User.find(params[:id])
  end

end
