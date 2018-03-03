class Api::V1::HomeVisitsController < Api::V1::BaseController

  def index
    @child = ProjectSeasonApplyChild.find(params[:id])
    @visits = @child.visits.sorted.page(params[:page]).per(params[:id])
    if @visits.present?
      api_success(data: {visits: @visits.map { |r| r.simple_builder }, pagination: json_pagination(@visits)})
    else
      api_success(data: {visits: [], pagination: json_pagination([])})
    end
  end

  def qrcode
    user = current_user.id
    @child = ProjectSeasonApplyChild.find(params[:id])
    url = "http://#{Settings.app_host}/cooperation/link-to-visit?type=home_visit&id=#{@child.id}&user=#{user}"
    api_success(data: {qrcode_url: url})
  end

  def get_child
    @child = ProjectSeasonApplyChild.find(params[:id])
    school = @child.school.name
    api_success(data: {school_name: school, child: @child.name})
  end

end
