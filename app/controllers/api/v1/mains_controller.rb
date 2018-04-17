class Api::V1::MainsController < Api::V1::BaseController

  def show
  end

  def banners
    @banners = Advert.banner.show.sorted
    api_success(data: @banners.map {|banner| banner.summary_builder})
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
    @campaigns = Campaign.show.sorted.take(6)
    api_success(data: @campaigns.map {|cam| cam.summary_builder})
  end

  def reads
    @reads = ProjectSeasonApply.show.raise_project.read_executing.pass.where(project: Project.read_project).sorted.take(3)
    api_success(data: @reads.map {|item| item.summary_builder})
  end

  def radios
    @radios = ProjectSeasonApply.show.raising.raise_project.pass.where(project: Project.radio_project).sorted.take(3)
    api_success(data: @radios.map {|item| item.summary_builder})
  end


  def flowers
    @flowers = ProjectSeasonApply.show.raising.raise_project.pass.where(project: Project.care_project).sorted.take(3)
    api_success(data: @flowers.map {|item| item.summary_builder})
  end

end
