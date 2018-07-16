class Admin::FinanceStatisticsController < Admin::BaseController
  before_action :auth_manage_operation

  def show
    params[:time_start] ||= Time.now.beginning_of_month.strftime("%Y-%m-%d")
    params[:time_end] ||= Time.now.strftime("%Y-%m-%d")
    income_records = IncomeRecord.joins(:fund).left_joins(:agent).select("income_no as finance_no, title, fund_id, income_time as finance_time, amount as income_amount, 0 as expend_amount, income_source_id, users.name as operator, income_records.remark")
    income_records = income_records.where("income_time >= ?", Time.parse(params[:time_start])) if params[:time_start].present?
    income_records = income_records.where("income_time <= ?", Time.parse(params[:time_end]).end_of_day) if params[:time_end].present?
    income_records = income_records.where("funds.fund_category_id = ?", params[:fund_category_id]) if params[:fund_category_id].present?
    income_records = income_records.where(fund_id: params[:fund_id]) if params[:fund_id].present?
    income_records = income_records.where(income_source_id: params[:income_source_id]) if params[:income_source_id].present?
    income_records = income_records.where("title like '%#{params[:keyword]}%' or income_records.remark like '%#{params[:keyword]}%'") if params[:keyword].present?


    expend_records = ExpenditureRecord.joins(:fund).select("expend_no as finance_no, expenditure_records.name as title, fund_id, expended_at as finance_time, 0 as income_amount, amount as expend_amount, income_source_id, operator, expenditure_records.remark")
    expend_records = expend_records.where("expended_at >= ?", Time.parse(params[:time_start])) if params[:time_start].present?
    expend_records = expend_records.where("expended_at <= ?", Time.parse(params[:time_end]).end_of_day) if params[:time_end].present?
    expend_records = expend_records.where("funds.fund_category_id = ?", params[:fund_category_id]) if params[:fund_category_id].present?
    expend_records = expend_records.where(fund_id: params[:fund_id]) if params[:fund_id].present?
    expend_records = expend_records.where(income_source_id: params[:income_source_id]) if params[:income_source_id].present?
    expend_records = expend_records.where("name like '%#{params[:keyword]}%' or expenditure_records.remark like '%#{params[:keyword]}%'") if params[:keyword].present?


    @income_count = income_records.sum(:amount)
    @expend_count = expend_records.sum(:amount)
    @balance_count = @income_count - @expend_count


    @finance_records = ApplicationRecord.connection.execute("select * from (#{expend_records.to_sql} UNION #{income_records.to_sql}) as finance_records order by finance_records.finance_time")
    @finance_records = @finance_records.to_a

    @funds = Fund.all.sorted
    @income_sources = IncomeSource.all.sorted

    respond_to do |format|
      format.html {
        @finance_records = Kaminari.paginate_array(@finance_records, total_count: @finance_records.size).page(params[:page]).per(50)
      }
      format.xlsx {
        @finance_records
        OperateLog.create_export_excel(current_user, '收支记录列表')
        response.headers['Content-Disposition'] = 'attachment; filename= "收支记录列表" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

end
