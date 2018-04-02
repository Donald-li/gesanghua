class Api::V1::DonationsController < Api::V1::BaseController

  def create
    donate_way = params[:donate_way]

    donor_id = params[:donor]
    agent = current_user
    team_id = current_user.team_id
    amount = params[:amount]

    donor = User.find donor_id if donor_id

    owner = DonateItem.find(params[:donate_item]) if params[:donate_item].present?
    owner = ProjectSeasonApply.find(params[:apply]) if params[:apply].present?
    owner = ProjectSeasonApplyChild.find(params[:child]) if params[:child].present?
    owner = ProjectSeasonApplyBookshelf.find(params[:bookshelf]) if params[:bookshelf].present?

    if params[:donate_way] == 'wechat'
      donation = Donation.new(amount: amount, owner: owner, donor_id: donor_id, agent_id: agent.id, team_id: team_id)
      if donation.save
        api_success(data: {order_no: donation.order_no, pay_state: donation.pay_state}, message: '成功')
      else
        api_error
      end
    elsif params[:donate_way] == 'balance'
      if DonateRecord.do_donate('user_donate', agent, owner, amount, agent, donor)
        api_success(data: {pay_state: 'paid'}, message: '成功')
      else
        api_error
      end
    end

  end
end
