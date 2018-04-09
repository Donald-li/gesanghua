class Site::CampaignsController < Site::BaseController

  def index
    @search = Campaign.show.sorted.ransack(params[:q])
    scope = @search.result
    @campaigns = scope.page(params[:page]).per(8)
  end

  def show
    @campaign = Campaign.find(params[:id])
    @recommends = Campaign.show.where.not(id: params[:id]).sorted.take(3)
  end

end
