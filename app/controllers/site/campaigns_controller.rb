class Site::CampaignsController < Site::BaseController
  before_action :logged_in?, only: [:submit]

  def index
    @search = Campaign.show.sorted.ransack(params[:q])
    scope = @search.result
    @campaigns = scope.page(params[:page]).per(8)
  end

  def show
    @campaign = Campaign.find(params[:id])
    @recommends = Campaign.show.where.not(id: params[:id]).sorted.take(3)
    unless current_user
      flash[:notice] = "您还没有登录，无法报名活动"
    end
  end

  def submit
    @campaign = Campaign.find(params[:id])
    total = @campaign.price.to_f * params[:adult_number].to_i + @campaign.child_price.to_f * params[:child_number].to_i
    @enlist = @campaign.campaign_enlists.new(params.permit(:contact_name, :contact_phone, :remark, :child_number, :adult_number).merge(number: params[:child_number].to_i + params[:adult_number].to_i))
    @enlist.form = params[:form]
    if @campaign.price > 0
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
      flash[:alert] = @enlist.errors.values.flatten.join(',')
      render :show
    end
  end

end
