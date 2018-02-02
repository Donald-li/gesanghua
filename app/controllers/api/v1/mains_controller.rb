class Api::V1::MainsController < Api::V1::BaseController

  def show
  end

  def banners
    @banners = Advert.visible.sorted
    api_success(data: @banners.map {|banner| banner.summary_builder})
  end

  def contribute
    amount = params[:amount].to_f
    team = current_user.team if params[:by_team] == 'true'
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    project = Project.find_project(params[:project][:value])
    fund = project.present? ? project.fund : Fund.first
    record = DonateRecord.create(user: current_user, fund: fund, amount: amount, team: team, donor: params[:donor], remitter_id: current_user.id, remitter_name: current_user.name)
    record.update(promoter_id: promoter.id) if promoter.present?
    record.update(project: project) if project.present?
    if true
      if params[:pay_method] == 'balance'
        current_user.balance -= amount
      end
      api_success(data: {pay_state: true, record_id: record.id}, message: '订单生成成功（暂时提示，应调用微信支付捐助成功后跳转结果页）')
    else
      api_success(data: {pay_state: false}, message: '订单生成失败，请重试')
    end
  end

  def campaigns

  end
end
