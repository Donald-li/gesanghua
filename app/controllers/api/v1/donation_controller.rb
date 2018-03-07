class Api::V1::DonationController < Api::V1::BaseController

  def create
    type = params[:type]

    if type == 'project'
      project_alias = params[:project]
      project = Project.find_by(alias: project_alias)
      record = DonateRecord.donate_project(current_user, params[:amount], project, params[:promoter], params[:item])

      if(record)
        if params[:pay_method] == 'balance'
          current_user.balance -= total
          current_user.save
          record.paid!
        end
        api_success(data: {record_state: true, order_id: record.id, pay_state: record.pay_state, user_info: current_user.summary_builder.merge(auth_token: current_user.auth_token)}.camelize_keys!, message: '订单生成成功')
      else
        api_success(data: {record_state: false}, message: '订单生成失败，请重试')
      end
    end
  end

end
