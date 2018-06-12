class Api::V1::PairChildrenController < Api::V1::BaseController
  before_action :set_pair, only: [:show, :complaint, :contribute, :settlement]

  def show
    api_error(message: '无效页面') && return unless @pair
    api_success(data: @pair.summary_builder(current_user))
  end

  def complaint
    api_error(message: '无效页面') && return unless @pair
    if SmsCode.valid_code?(mobile: complaint_params[:contact_phone], code: params[:code], kind: 'verify_profile', write_verified: true)
      complaint = Complaint.find_by(contact_phone: complaint_params[:contact_phone], owner: @pair, user: current_user)
      if complaint.present?
        api_success(message: '您已经提交过举报信息', data: false)
      else
        @complaint = Complaint.new(complaint_params.merge(user: current_user))
        @complaint.owner = @pair
        if @complaint.save
          @complaint.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
          api_success(message: '举报成功，管理员会尽快处理', data: true)
        else
          api_success(message: '提交失败，请重试', data: false)
        end
      end
    else
      api_error(message: '验证码错误')
    end
  end

  def contribute
    api_error(message: '无效页面') && return unless @pair
    api_success(data: {child_info: @pair.detail_builder})
  end

  # 处理结对捐款
  # TODO: 使用统一的支付接口
  def settlement
    semester_num = params[:selected_grants].count
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    record = DonateRecord.donate_child(user: current_user, child: @pair, semester_num: semester_num, promoter: promoter)
    record.team = current_user.team
    record.donor = params[:donor] if params[:donor].present?

    if record.save
      if params[:pay_method] == 'balance'
        current_user.deduct_balance(record.amount)
        record.paid!
      end
      @pair.hidden!  # TODO 确认支付成功时隐藏孩子
      api_success(data: {record_state: true, order_id: record.id, pay_state: record.pay_state, user_info: current_user.summary_builder.merge(auth_token: current_user.auth_token)}.camelize_keys!, message: '订单生成成功')
    else
      api_success(data: {record_state: false}, message: '订单生成失败，请重试')
    end
  end

  def get_child_priority
    message = '被捐助学生已被指定优先捐助人，请联系管理员处理'
    @child = ProjectSeasonApplyChild.find(params[:child_id])
    donor = current_user
    if @child.priority_id.present? and donor.id != @child.priority_id and !donor.offline_users.pluck(:id).include?(@child.priority_id) and @child.hidden?
      api_error(message: message)
    else
      api_success(message: '可资助', data: true)
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
