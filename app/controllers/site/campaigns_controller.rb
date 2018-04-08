class Site::CampaignsController < Site::BaseController

  def index
    @search = Campaign.show.sorted.ransack(params[:q])
    scope = @search.result
    @campaigns = scope.page(params[:page])
  end

  def show
    @campaign = Campaign.find(params[:id])
  end
end
