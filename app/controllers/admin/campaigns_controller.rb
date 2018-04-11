class Admin::CampaignsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :switch, :switch_state]

  def index
    @search = Campaign.sorted.ransack(params[:q])
    scope = @search.result
    @campaigns = scope.page(params[:page])
  end

  def show
  end

  def new
    @campaign = Campaign.new
  end

  def edit
  end

  def create
    @campaign = Campaign.new(campaign_params)
    respond_to do |format|
      if @campaign.save
        @campaign.attach_image(params[:image_id])
        @campaign.attach_banner(params[:banner_id])
        format.html { redirect_to referer_or(admin_campaigns_url), notice: '活动已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        @campaign.attach_image(params[:image_id])
        @campaign.attach_banner(params[:banner_id])
        format.html { redirect_to referer_or(admin_campaigns_url), notice: '活动已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_campaigns_url), notice: '活动已删除。' }
    end
  end

  def switch
    @campaign.show? ? @campaign.hidden! : @campaign.show!
    redirect_to admin_campaigns_url, notice:  @campaign.show? ? '活动已展示' : '活动已隐藏'
  end

  def switch_state
    @campaign.execute_state = params[:execute_state]
    respond_to do |format|
      if @campaign.save
        format.html { redirect_to admin_campaigns_url, notice: '标记成功。' }
      else
        format.html { redirect_to admin_campaigns_url, notice: '标记失败。' }
      end
    end
  end

  private
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def campaign_params
      params.require(:campaign).permit!
    end
end
