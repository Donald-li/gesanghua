class Admin::CampaignEnlistsController < Admin::BaseController

  before_action :set_campaign_enlist, only: [:show, :edit, :update, :destroy, :cancel, :calculate_total_price]
  before_action :set_campaign, only: [:index, :new, :create, :edit, :update, :cancel, :excel_output]

  def index
    @search = @campaign.campaign_enlists.sorted.ransack(params[:q])
    scope = @search.result
    @campaign_enlists = scope.page(params[:page])
  end

  def excel_output
    path = ExcelOutput.campaign_enlist_output(@campaign)
    file_name = "活动报名表.xlsx"
    send_file(path, filename: file_name)
  end

  def new
    @campaign_enlist = @campaign.campaign_enlists.new
  end

  def edit
  end

  def create
    @campaign_enlist = @campaign.campaign_enlists.new(campaign_enlist_params.except(:payment_state))
    @campaign_enlist.payment_state = campaign_enlist_params[:payment_state] if !campaign_enlist_params[:payment_state].blank?
    respond_to do |format|
      if @campaign_enlist.save
        format.html { redirect_to referer_or(admin_campaign_campaign_enlists_path(@campaign)), notice: '报名创建成功。' }
      else
        format.html { render :new  }
      end
    end
  end

  def update
    respond_to do |format|
      @campaign_enlist.payment_state = campaign_enlist_params[:payment_state] if !campaign_enlist_params[:payment_state].blank?
      if @campaign_enlist.update(campaign_enlist_params.except(:payment_state))
        format.html { redirect_to referer_or(admin_campaign_campaign_enlists_path(@campaign)), notice: '报名信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def cancel
    store_referer
    @campaign_enlist.update(payment_state: 2)
    redirect_to referer_or(admin_campaign_campaign_enlists_path(@campaign)), notice: '报名已取消'
  end

  def calculate_total_price
    @campaign_enlist.total = @campaign_enlist.campaign.price * params[:q]
    render json: {items: @campaign_enlist.total.as_json(only: [params[:q], :total])}

    # scope = School.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    # schools = scope.page(params[:page])
    # render json: {items: schools.as_json(only: [:id, :name])}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign_enlist
      @campaign_enlist = CampaignEnlist.find(params[:id])
    end

    def set_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_enlist_params
      params.require(:campaign_enlist).permit!
    end

end
