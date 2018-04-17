class Api::V1::Account::DonateRecordsController < Api::V1::BaseController

  def index
    donations = current_user.donate_records.where.not(project_id: nil).sorted.page(params[:page]).per(params[:per])
    donations = donations.where(project_id: params[:project_id].to_i) if params[:project_id].present? && params[:project_id] != 'all'
    api_success(data: {donate_records: donations.map { |r| r.summary_builder }, pagination: json_pagination(donations)})
  end

  def projects
    api_success(data: Project.sorted.map { |p| {id: p.id, name: p.name} })
  end

  def record_details
    record = current_user.income_records.find(params[:id])
    api_success(data: record.summary_builder)
  end

  # 捐款记录
  def account_records
    records = current_user.income_records.sorted
    api_success(data: {donateRecords: records.map { |r| r.summary_builder }, donateAmount: current_user.donate_amount})
  end

  def voucher_records
    records = current_user.income_records.to_bill.sorted
    api_success(data: {records: records.map { |r| r.summary_builder }, donate_amount: current_user.donate_amount})
  end

end
