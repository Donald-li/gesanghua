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
    amount = params[:amount]
    team = current_user.team if params[:by_team] == 'true'
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    record = DonateRecord.create(user: current_user, fund: @pair.project.fund, amount: amount, project: @pair.project, team: team, donor: params[:donor], remitter_id: current_user.id, remitter_name: current_user.name, season: @pair.season, apply: @pair.apply, child: @pair)
    record.update(promoter_id: promoter.id, promoter_name: promoter.name) if promoter.present?
    if true
      if params[:pay_method] == 'balance'
        current_user.balance -= total
      end
      api_success(data: {pay_state: true}, message: '订单生成成功（暂时提示，应调用微信支付捐助成功后跳转结果页）')
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
