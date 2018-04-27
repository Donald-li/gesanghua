class Account::CampaignsController < Account::BaseController

  def index
    @camapigns = Campaign.where(id: current_user.campaign_enlists.paid.pluck(:campaign_id)).sorted.page(params[:page])
  end
end
