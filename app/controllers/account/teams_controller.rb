class Account::TeamsController < Account::BaseController
  before_action :set_team, only: [:edit, :update, :dismiss]

  def index
    @has_team = current_user.team.present?
    if @has_team
      @team = current_user.team
      @team_manager = @team.manager
      @team_creater = @team.creater
      @team_members = @team.users.where.not(id: [@team_manager.id, @team_creater.id]).sorted
    end
  end

  def guide
  end

  def new
    @team = Team.new(kind: params[:kind], creater: current_user, manager: current_user)
  end

  def create
    @team = Team.new(team_params)
    @team.creater = current_user
    @team.manager = current_user
    if @team.save
      @team.attach_logo(params[:logo_id])
      current_user.update(team: @team, join_team_time: Time.now)
      redirect_to account_teams_path, notice: '创建成功。'
    else
      flash[:alert] = '创建失败，请重试。'
      render :new
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      @team.attach_logo(params[:logo_id])
      redirect_to account_teams_path, notice: '修改成功。'
    else
      flash[:alert] = '修改失败，请重试。'
      render :edit
    end
  end

  def exit_team
    if current_user.update(team_id: nil)
      redirect_to account_teams_path, notice: '退出团队成功。'
    else
      flash[:alert] = '退出团队失败，请重试。'
      render :index
    end
  end

  private
  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit!
  end

end
