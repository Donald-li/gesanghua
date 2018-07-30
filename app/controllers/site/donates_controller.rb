class Site::DonatesController < Site::BaseController
  before_action :login_require

  def new
    if params[:child].present?
      @project = Project.pair_project
    elsif params[:apply].present?
      @apply = ProjectSeasonApply.find(params[:apply])
      @surplus_money = @apply.surplus_money
      @project = @apply.project
    elsif params[:bookshelf].present?
      @project = Project.read_project
      @apply = ProjectSeasonApplyBookshelf.find(params[:bookshelf]).apply
      @surplus_money = @apply.surplus_money
    end

    if @project
      @amount_tabs = @project.amount_tabs(@surplus_money)
    else
      @amount_tabs = Settings.amount_tabs
    end

    @donors = current_user.offline_users.unactived.reverse_sorted

    @donate_itmes = DonateItem.includes(:amount_tabs).sorted.show
    @protocol = Protocol.donate_protocol.first

    render 'child' if params[:child].present?
    render 'apply' if params[:apply].present?
    render 'bookshelf' if params[:bookshelf].present?
    render 'campaign_enlist' if params[:campaign_enlist].present?

  end

  def create
    donate_way = params[:donate_way]

    agent = current_user
    donor_id = params[:donor].presence || agent.id
    team_id = current_user.team_id
    amount = params[:amount]
    promoter_id = params[:promoter] || session[:promoter_id]
    promoter_id = nil if promoter_id.to_i == agent.id

    donor = User.find donor_id if donor_id

    owner = DonateItem.find(params[:donate_item]) if params[:donate_item].present?
    owner = ProjectSeasonApply.find(params[:apply]) if params[:apply].present?
    owner = ProjectSeasonApplyChild.find(params[:child]) if params[:child].present?
    owner = ProjectSeasonApplyBookshelf.find(params[:bookshelf]) if params[:bookshelf].present?
    owner = CampaignEnlist.find(params[:campaign_enlist]) if params[:campaign_enlist].present? # 活动报名

    if params[:donate_way] == 'wechat'
      donation = Donation.new(pay_way: :wechat, amount: amount, owner: owner, donor_id: donor_id, agent_id: agent.id, team_id: team_id, promoter_id: promoter_id, message: params[:message])
      if donation.save
        redirect_to new_pay_path(order_no: donation.order_no)
      end
    elsif params[:donate_way] == 'alipay'
      donation = Donation.new(pay_way: :alipay, amount: amount, owner: owner, donor_id: donor_id, agent_id: agent.id, team_id: team_id, promoter_id: promoter_id, message: params[:message])
      if donation.save
        redirect_to donation.alipay_prepay_page
      end
    elsif params[:donate_way] == 'balance'
      result, message = DonateRecord.do_donate('user_donate', agent, owner, amount, {agent: agent, donor: donor, message: params[:message]})
      if result
        redirect_to account_orders_path
      end
    end
  end
end
