class Api::V1::Account::CampaignsController < Api::V1::BaseController

  def index
    campaigns = current_user.campaigns.sorted.page(params[:page]).per(params[:per])
    api_success(data: {campaigns: campaigns.map{|cam| cam.summary_builder(current_user)}, pagination: json_pagination(campaigns)})
  end

end
