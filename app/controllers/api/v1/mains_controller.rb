class Api::V1::MainsController < Api::V1::BaseController

  def show
  end

  def banners
    @banners = Advert.visible.sorted
    api_success(data: @banners.map {|banner| banner.summary_builder})
  end

  def contribute
    @donate_items = DonateItem.show.sorted
    api_success(data: @donate_items.map{|donate_item| donate_item.summary_builder})
  end

  def settlement
    amount = params[:amount].to_f
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    donate_item = DonateItem.find(params[:donate_item][:value])
    record = DonateRecord.donate_donate_item(current_user, amount, donate_item, promoter)
    record.team = current_user.team if params[:by_team] == 'true'
    record.donor = params[:donor] if params[:donor].present?

    if record.save
      if params[:pay_method] == 'balance'
        current_user.balance -= amount
        current_user.save
        record.paid!
      end
      api_success(data: {record_state: true, record_id: record.id, promoter_id: record.promoter_id, user_info: current_user.summary_builder.merge(auth_token: current_user.auth_token)}, message: '订单生成成功（暂时提示，应调用微信支付捐助成功后跳转结果页）')
    else
      api_success(data: {record_state: false}, message: '订单生成失败，请重试')
    end
  end

  def month_contribute
    amount = params[:amount].to_f
    plan_period = params[:period].to_i
    donate_item = Donation.find(params[:donate_item][:value])
    record = MonthDonate.month_donate_donate_item(current_user, amount, donate_item, plan_period)
    if record.save
      api_success(data: {record_state: true, record_id: record.id, user_info: current_user.summary_builder.merge(auth_token: current_user.auth_token)}, message: '订单生成成功（暂时提示，应调用微信支付捐助成功后跳转结果页）')
    else
      api_success(data: {record_state: false}, message: '订单生成失败，请重试')
    end
  end

  def campaigns

  end
end
