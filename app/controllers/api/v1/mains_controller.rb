class Api::V1::MainsController < Api::V1::BaseController

  def show
  end

  def banners
    @banners = Advert.visible.sorted
    api_success(data: @banners.map {|banner| banner.summary_builder})
  end

  def contribute
    amount = params[:amount].to_f
    if params[:pay_method] == 'balance_and_weixin'
      payment = amount - current_user.balance
    else
      payment = amount
    end
    team = current_user.team if params[:by_team] == 'true'
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    donor = params[:donor] || current_user.name
    project = Project.find_project(params[:project][:value])
    fund = project.present? ? project.fund : Fund.first
    record = DonateRecord.create(user: current_user, fund: fund, amount: amount, team: team, donor: donor, remitter_id: current_user.id, remitter_name: current_user.name)
    record.update(promoter_id: promoter.id) if promoter.present?
    record.update(project: project) if project.present?
    if params[:pay_method] == 'weixin' || params[:pay_method] == 'balance_and_weixin'
      # TODO: 这里调用微信支付,支付金额为payment,在支付成功时扣除用户相应余额
    end
    # 支付成功后，更新捐助记录的支付状态，生成收入记录
    if true
      if params[:pay_method] == 'balance_and_weixin'
        current_user.balance = 0
      elsif params[:pay_method] == 'balance'
        current_user.balance -= amount
      end
      record.paid!
      IncomeRecord.create(donate_record: record, user: record.user, fund: record.fund, amount: record.amount, remitter_id: record.remitter_id, remitter_name: record.remitter_name, donor: record.donor, promoter_id: record.promoter_id, income_time: Time.now)
      api_success(data: {pay_state: true}, message: '支付成功（暂时提示，应跳转捐助成功页面）')
    else
      api_success(data: {pay_state: false}, message: '支付失败，请重试')
    end
  end

  def campaigns

  end
end
