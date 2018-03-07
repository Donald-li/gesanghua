class Api::V1::FeedbacksController < Api::V1::BaseController
  skip_before_action :login? unless Settings.development_mode

  def index
    if (params[:type] == 'execute')
      query_types = ['ReceiveFeedback', 'InstallFeedback']
    else
      query_types = ['ReceiveFeedback']
    end
    feedbacks = Feedback.show.pass.sorted.where(type: query_types).where(project_season_apply_id: params[:apply_id]).page(params[:page]).per(7)
    api_success(data: {feedbacks: feedbacks.map { |r| r.detail_builder }, pagination: json_pagination(feedbacks)})
  end

end
