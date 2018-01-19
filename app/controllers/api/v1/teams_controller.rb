class Api::V1::TeamsController < Api::V1::BaseController

  def index
    @user = User.find(params[:id])
    if @user.team.present?
      api_success(data: {has_team: 'true', team: @user.team.summary_builder})
    else
      api_success(data: {has_team: 'false'})
    end
  end

end
