class Api::V1::DonatesController < Api::V1::BaseController

  # 捐助相关接口
  def item
    type = params[:type]
    amount = params[:amount].to_f

    if type == 'project'
      project_alias = params[:project]
      project = Project.find_by(alias: project_alias)
      record = DonateRecord.donate_project(current_user, params[:amount], project, params[:promoter], params[:item])
      record.paid! if Settings.skip_pay_mode

      if(record)
        if params[:pay_method] == 'balance'
          current_user.deduct_balance(amount)
          record.paid!
        end
        api_success(data: {record_state: true, order_id: record.id, pay_state: record.pay_state, user_info: current_user.summary_builder.merge(auth_token: current_user.auth_token)}.camelize_keys!, message: '订单生成成功')
      else
        api_success(data: {record_state: false}, message: '订单生成失败，请重试')
      end
    end
  end

  def apply
    apply_id = params[:apply_id]
    amount = params[:amount].to_f
    promoter = Uesr.find(params[:promoter_id]) if params[:promoter_id].present?

    apply = ProjectSeasonApply.find(apply_id)
    project = apply.project

    donate_record = DonateRecord.donate_apply(user: current_user, amount: params[:amount].to_f, apply: apply, promoter: promoter)

    if Settings.skip_pay_mode
      income_record = IncomeRecord.new(user: donate_record.user, voucher_state: 'to_bill', income_source_id: 1, amount: donate_record.amount, balance: donate_record.amount, income_time: Time.now)
      income_record.save
      donate_record.pay_state = 'paid'
      donate_record.income_record = income_record
      donate_record.save
      DonateRecord.use_income_record_donate_bookshelf(params, income_record)
    end

    if (donate_record)
      api_success(data: {record_state: true, order_id: donate_record.id, pay_state: donate_record.pay_state, user_info: current_user.summary_builder.merge(auth_token: current_user.auth_token)}.camelize_keys!, message: '订单生成成功')
    else
      api_success(data: {record_state: false}, message: '订单生成失败，请重试')
    end

  end

  def gsh
    amount = params[:amount].to_f
    promoter = User.find(params[:promoter_id]) if params[:promoter_id].present?
    donate_item = DonateItem.find(params[:donate_item][:value])
    record = DonateRecord.donate_donate_item(user: current_user, amount: amount, donate_item: donate_item, promoter: promoter)
    record.team = current_user.team if params[:by_team] == 'true'
    record.donor = params[:donor] if params[:donor].present?
    record.pay_state = 'paid' if Settings.skip_pay_mode

    if record.save
      if params[:pay_method] == 'balance'
        if current_user.deduct_balance(amount)
          record.paid!
        end
      end
      api_success(data: record.detail_builder.merge(recordState: true), message: '订单生成成功')
    else
      api_success(data: {record_state: false}, message: '订单生成失败，请重试')
    end
  end

end
