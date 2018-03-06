class Api::V1::ActivitiesController < Api::V1::BaseController

  def index
    @activities = Campaign.show.sorted.page(params[:page]).per(params[:per])
    api_success(data: {activities: @activities.map { |r| r.summary_builder }, pagination: json_pagination(@activities)})
  end

  def show
    @activity = Campaign.find(params[:id])
    api_success(data: {activity: @activity.detail_builder})
  end

end
