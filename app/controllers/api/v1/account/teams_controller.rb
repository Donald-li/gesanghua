class Api::V1::Account::TeamsController < Api::V1::BaseController
  before_action :set_team, only: [:show, :edit, :update, :member, :donate_records, :turn_team, :dismiss, :join_team, :exit_team]

  def index
    teams = Team.sorted.where(kind: params[:kind]).where.not(manage_id: nil)
    teams = teams.where("name like ?", "%#{params[:team_name]}%") if params[:team_name].present?
    teams = teams.page(params[:page]).per(params[:per])
    api_success(data: {teams: teams.map{|team| team.summary_builder}, pagination: json_pagination(teams)})
  end

  def create
    team = Team.new(team_params.merge(province: params[:location][0], city: params[:location][1], district: params[:location][2], kind: params[:kind], creater_id: current_user.id, manage_id: current_user.id))
    if team.save
      team.attach_logo(params[:logo_id])
      current_user.update(team: team, join_team_time: Time.now)
      team.update(member_count: team.users.count)
      api_success(message: '创建成功', data: true)
    else
      api_success(message: '创建失败，请重试', data: false)
    end
  end

  def show
    api_success(data: {team: @team.summary_builder, user_status: @team.user_status(current_user.id)})
  end

  def edit
    api_success(data: {team: @team.detail_builder})
  end

  def update
    if @team.update(team_params)
      @team.attach_logo(params[:logo_id])
      api_success(data: true, message: '修改成功')
    else
      api_success(data: false, message: '修改失败')
    end
  end

  def turn_team
    user = User.find(params[:user_id])
    if user.present? && @team.update(manager: user)
      api_success(data: true, message: '移交成功')
    else
      api_success(data: false, message: '移交失败')
    end
  end

  def dismiss
    if @team.users.update(team_id: nil)
      @team.update(manage_id: nil, member_count: @team.users.count)
      api_success(data: true, message: '解散成功')
    else
      api_success(data: false, message: '解散失败')
    end
  end

  def join_team
    if current_user.update(team_id: @team.id)
      @team.update(member_count: @team.users.count)
      api_success(data: true, message: '你已成功加入团队~')
    else
      api_success(data: false, message: '加入失败，请重试')
    end
  end

  def exit_team
    if current_user.update(team_id: nil)
      @team.update(member_count: @team.users.count)
      api_success(data: true, message: '你已成功退出团队')
    else
      api_success(data: false, message: '退出失败，请重试')
    end
  end

  def member
    if params[:type] == 'turn'
      users = @team.users.where.not(id: current_user.id).sorted
      api_success(data: {member: users.map{|user| user.summary_builder}})
    else
      users = @team.users.sorted.page(params[:page]).per(params[:per])
      api_success(data: {member: users.map{|user| user.summary_builder}, pagination: json_pagination(users)})
    end
  end

  def donate_records
    records = DonateRecord.where(user_id: @team.users.pluck(:id)).sorted.page(params[:page]).per(params[:per])
    api_success(data: {records: records.map{|record| record.detail_builder}, pagination: json_pagination(records)})
  end

  private
  def team_params
    params.require(:team).permit!
  end

  def set_team
    @team = Team.find(params[:id])
  end

end
