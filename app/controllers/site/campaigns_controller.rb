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

  def submit
    @campaign = Campaign.find(params[:id])
    keys = @campaign.form.map{|i| i['key']} # 动态字段
    total = @campaign.price.to_f * params[:number].to_i
    @enlist = @campaign.campaign_enlists.new(params.permit(:contact_name, :contact_phone, :number, :remark, form: keys))
    if @campaign.price
      #TODO: 交报名费
      # @enlist.state = :paid
      @enlist.total = total
    else
      @enlist.state = :paid
    end
    @enlist.user = current_user
    if @enlist.save
      if @enlist.paid?
        redirect_to campaign_path, notice: '报名成功'
      else
        redirect_to new_donate_path(campaign_enlist: @enlist.id)
      end
    else
      redirect_to campaign_path, alert: '报名失败'
    end
  end

end
