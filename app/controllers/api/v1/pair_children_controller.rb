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
      api_success(message: '您已经提交过举报信息', data: false)
    else
      @complaint = Complaint.new(complaint_params)
      @complaint.owner = @pair
      if @complaint.save
        @complaint.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
        api_success(message: '举报成功，管理员会尽快处理', data: true)
      else
        api_success(message: '提交失败，请重试', data: false)
      end
    end
  end

  def contribute
    api_error(message: '无效页面') && return unless @pair
    api_success(data: {child_info: @pair.detail_builder})
  end

  def settlement
    semester_num = params[:selected_grants].count
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    record = DonateRecord.donate_child(user: current_user, gsh_child: @pair, semester_num: semester_num, promoter: promoter)
    record.team = current_user.team
    record.donor = params[:donor] if params[:donor].present?

    if record.save
      if params[:pay_method] == 'balance'
        current_user.balance -= total
        current_user.save
        record.paid!
      end
      @pair.hidden!  # TODO 确认支付成功时隐藏孩子
      api_success(data: {record_state: true, record_id: record.id, user_info: current_user.summary_builder.merge(auth_token: current_user.auth_token)}, message: '订单生成成功（暂时提示，应调用微信支付捐助成功后跳转结果页）')
    else
      api_success(data: {record_state: false}, message: '订单生成失败，请重试')
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
