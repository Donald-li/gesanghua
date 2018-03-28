class Api::V1::CampaignsController < Api::V1::BaseController

  def index
    @campaigns = Campaign.show.sorted.page(params[:page])
    api_success(data: {list: @campaigns.map(&:summary_builder), pagination: json_pagination(@campaigns)})
  end

  def show
    @campaign = Campaign.show.find(params[:id])
    api_success(data: @campaign.detail_builder(current_user))
  end

  # 提交报名表单
  def apply
    @campaign = Campaign.show.find(params[:id])
    @enlist = @campaign.campaign_enlists.new(params.permit(:contact_name, :contact_phone, :number, :form, :remark))
    if @campaign.price
      #TODO: 交报名费
      # @enlist.state = :paid
    else
      @enlist.state = :paid
    end
    @enlist.user = current_user
    if @enlist.save
      api_success(data: @enlist.id)
    else
      api_error(message: @enlist.errors.messages)
    end
  end

  def success
    @enlist = CampaignEnlist.where(user: current_user).paid.find(params[:id])
    @another_campaign = Campaign.show.where.not(id: @enlist.campaign.id).sorted.first #
    api_success(data: {totalPrice: @enlist.total_price, campaignId: @enlist.campaign_id, campaign: @another_campaign.try(:summary_builder) || {}})
  end

end
