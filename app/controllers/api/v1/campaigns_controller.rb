class Api::V1::CampaignsController < Api::V1::BaseController

  def index
    @campaigns = Campaign.show.sorted.page(params[:page])
    api_success(data: {list: @campaigns.map{|cam| cam.summary_builder}, pagination: json_pagination(@campaigns)})
  end

  def show
    @campaign = Campaign.show.find(params[:id])
    api_success(data: @campaign.detail_builder(current_user))
  end

  # 提交报名表单
  def apply
    @campaign = Campaign.show.find(params[:id])
    total = @campaign.price.to_f * params[:adult_number].to_i + @campaign.child_price.to_f * params[:child_number].to_i
    @enlist = @campaign.campaign_enlists.new(params.permit(:contact_name, :contact_phone, :remark, :child_number, :adult_number).merge(number: params[:child_number].to_i + params[:adult_number].to_i))
    @enlist.form = params[:form]
    if @campaign.price
      #TODO: 交报名费
      # @enlist.state = :paid
      @enlist.total = total
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
