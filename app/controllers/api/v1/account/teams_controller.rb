class Api::V1::Account::TeamsController < Api::V1::BaseController

  def index
    @search = Team.sorted.where(kind: params[:kind]).ransack(params[:q])
    scope = @search.result
    teams = scope.page(params[:page]).per(params[:per])
    api_success(data: {teams: teams.map{|team| team.summary_builder}, pagination: json_pagination(teams)})
  end

  def create
    team = Team.new(team_params.merge(province: params[:location][0], city: params[:location][1], district: params[:location][2], kind: params[:kind], creater_id: current_user.id, manage_id: current_user.id))
    if team.save
      team.attach_logo(params[:logo_id])
      current_user.update(team: team, join_team_time: Time.now)
      api_success(message: '创建成功', data: true)
    else
      api_success(message: '创建失败，请重试', data: false)
    end
  end

  def show
    team = Team.find(params[:id])
    api_success(data: {team: team.summary_builder, user_status: team.user_status(current_user.id)})
  end

  def member
    users = Team.find(params[:id]).users.sorted.page(params[:page]).per(params[:per])
    api_success(data: {member: users.map{|user| user.summary_builder}, pagination: json_pagination(users)})
  end

  def donate_records
    records = DonateRecord.where(user_id: Team.find(params[:id]).users.pluck(:id)).sorted.page(params[:page]).per(params[:per])
    api_success(data: {records: records.map{|record| record.detail_builder}, pagination: json_pagination(records)})
  end

  private
  def team_params
    params.require(:team).permit!
  end

end
