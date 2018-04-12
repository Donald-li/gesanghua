class Account::CampaignsController < Account::BaseController

  def index
    @camapigns = current_user.campaigns.sorted.page(params[:page])
  end
end
