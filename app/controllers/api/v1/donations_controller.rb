class Api::V1::DonationsController < Api::V1::BaseController

  def create
    donate_way = params[:donate_way]

    donor_id = params[:donor]
    agent = current_user
    team_id = current_user.team_id
    amount = params[:amount]
    promoter_id = params[:promoter]

    donor = User.find donor_id if donor_id

    owner = DonateItem.find(params[:donate_item]) if params[:donate_item].present?
    owner = ProjectSeasonApply.find(params[:apply]) if params[:apply].present?
    owner = ProjectSeasonApplyChild.find(params[:child]) if params[:child].present?
    owner = ProjectSeasonApplyBookshelf.find(params[:bookshelf]) if params[:bookshelf].present?
    owner = CampaignEnlist.find(params[:campaign_enlist]) if params[:campaign_enlist].present? # 活动报名

  if params[:donate_way] == 'wechat'
      donation = Donation.new(amount: amount, owner: owner, donor_id: donor_id, agent_id: agent.id, team_id: team_id, promoter_id: promoter_id, project: owner.try(:project).presence, season: owner.try(:season).presence, apply: owner.try(:apply).presence)
      if donation.save
        api_success(data: {order_no: donation.order_no, pay_state: donation.pay_state}.camelize_keys!, message: '成功')
      else
        api_error
      end
    elsif params[:donate_way] == 'balance'
      if DonateRecord.do_donate('user_donate', agent, owner, amount, {agent: agent, donor: donor})
        api_success(data: {pay_state: 'paid'}.camelize_keys!, message: '成功')
      else
        api_error
      end
    end

  end

  def show
    donation = Donation.find_by(order_no: params[:id])
    api_success(data: {donation: donation.detail_builder})
  end
end
