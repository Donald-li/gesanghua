class Api::V1::DonationsController < Api::V1::BaseController

  def create

    donor_id = params[:donor]
    agent = current_user
    team_id = current_user.team_id
    amount = params[:amount].to_s.gsub(',', '') # 有的有格式
    promoter_id = params[:promoter]
    promoter_id = nil if promoter_id.to_i == agent.id

    donor = User.find donor_id if donor_id

    owner = DonateItem.find(params[:donate_item]) if params[:donate_item].present?
    owner = ProjectSeasonApply.find(params[:apply]) if params[:apply].present?
    owner = ProjectSeasonApplyBookshelf.find(params[:bookshelf]) if params[:bookshelf].present?
    owner = CampaignEnlist.find(params[:campaign_enlist]) if params[:campaign_enlist].present? # 活动报名

    if params[:child].present?
      owner = ProjectSeasonApplyChild.find(params[:child])
      #两小时内的捐助订单判断  已完成捐助判断
      if Donation.where(owner: owner).where('created_at > :time', time: Time.now - 0.5.hours).where.not(agent_id: agent.id).present?
        api_error(message: '该孩子有人正在捐助，请稍后再试或看看其他孩子') && return
      end
    end

    if params[:donate_way] == 'wechat'
      donation = Donation.new(amount: amount, owner: owner, donor_id: donor_id, agent_id: agent.id, team_id: team_id, promoter_id: promoter_id, message: params[:message])
      if donation.save
        api_success(data: {order_no: donation.order_no, pay_state: donation.pay_state}.camelize_keys!, message: '成功')
      else
        api_error
      end
    elsif params[:donate_way] == 'balance'
      result, message = DonateRecord.do_donate('user_donate', agent, owner, amount, {agent: agent, donor: donor, team_id: team_id, promoter_id: promoter_id, message: params[:message]})
      if result
        api_success(data: {pay_state: 'paid', bookshelf: params[:bookshelf], amount: params[:amount]}.camelize_keys!, message: message)
      else
        api_success(data: {pay_state: 'error'}.camelize_keys!, message: message)
      end
    end
  end

  def show
    donation = Donation.find_by(order_no: params[:id])
    api_success(data: {donation: donation.detail_builder})
  end
end
