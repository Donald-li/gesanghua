class Api::V1::PairChildrenController < Api::V1::BaseController
  before_action :set_pair, only: [:show, :complaint, :contribute, :settlement]

  def show
    api_error(message: '无效页面') && return unless @pair
    api_success(data: @pair.summary_builder)
  end

  def complaint
    api_error(message: '无效页面') && return unless @pair
    complaint = Complaint.find_by(contact_phone: complaint_params[:contact_phone], owner: @pair)
    if complaint.present?
      api_success(message: '您已经提交过举报信息')
    else
      @complaint = Complaint.new(complaint_params)
      @complaint.owner = @pair
      if @complaint.save
        @complaint.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        api_success(message: '举报成功，管理员会尽快处理')
      else
        api_success(message: '提交失败，请重试')
      end
    end
  end

  def contribute
    api_error(message: '无效页面') && return unless @pair
    api_success(data: {child_info: @pair.detail_builder})
  end

  def settlement
    current_user = User.second # TODO: 这里需要处理
    total = params[:total_amount]
    if params[:pay_method] == 'balance_and_weixin'
      payment = total - current_user.balance
    else
      payment = total
    end
    team = current_user.team if params[:by_team] == 'true'
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    donor = params[:donor_name] || current_user.name
    grants = GshChildGrant.where(id: params[:selected_grants].map {|grant| grant[:id]})
    grants.each do |grant|
      record = current_user.donate_records.find_or_create_by(user: current_user, fund: @pair.project.fund, amount: grant[:amount].to_f, project: @pair.project, team: team, donor: donor, remitter_id: current_user.id, remitter_name: current_user.name, season: @pair.season, apply: @pair.apply, project_season_apply_child: @pair)
      record.update(promoter_id: promoter.id) if promoter.present?
    end
    if params[:pay_method] == 'weixin' || params[:pay_method] == 'balance_and_weixin'
      # TODO: 这里调用微信支付,支付金额为payment,在支付成功时扣除用户相应余额
    end
    # 支付成功后，更新捐助记录的支付状态，生成收入记录
    if true
      if params[:pay_method] == 'balance_and_weixin'
        current_user.balance = 0
      elsif params[:pay_method] == 'balance'
        current_user.balance -= total
      end
      current_user.donate_records.where(project_season_apply_child: @pair).each do |record|
        record.paid!
        IncomeRecord.create(donate_record: record, user: record.user, fund: record.fund, amount: record.amount, remitter_id: record.remitter_id, remitter_name: record.remitter_name, donor: record.donor, promoter_id: record.promoter_id, income_time: Time.now)
      end
      grants.each do |grant|
        grant.succeed!
      end
      if !@pair.gsh_child.gsh_child_grants.detect {|grant| grant if grant.pending?}.present?
        @pair.hidden!
      end
      api_success(data: {pay_state: true}, message: '支付成功（暂时提示，应跳转捐助成功页面）')
    else
      api_success(data: {pay_state: false}, message: '支付失败，请重试')
    end
  end

  private

  def set_pair
    @pair = ProjectSeasonApplyChild.find(params[:id])
  end

  def complaint_params
    params.require(:complaint).permit!
  end

end
