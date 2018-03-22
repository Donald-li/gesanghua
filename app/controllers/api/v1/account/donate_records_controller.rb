class Api::V1::Account::DonateRecordsController < Api::V1::BaseController

  def index
    donate_records = current_user.donate_records.where.not(project_id: nil).paid.sorted.page(params[:page]).per(params[:per])
    donate_records = donate_records.where(project_id: params[:project_id].to_i) if params[:project_id].present? && params[:project_id] != 'all'
    api_success(data: {donate_records: donate_records.map { |r| r.detail_builder }, pagination: json_pagination(donate_records)})
  end

  def projects
    api_success(data: Project.sorted.map { |p| {id: p.id, name: p.name} })
  end

  def record_details
    donate_record = DonateRecord.find(params[:id])
    api_success(data: donate_record.detail_builder)
  end

  def account_records
    donate_records = current_user.donate_records.paid.sorted
    api_success(data: {donate_records: donate_records.map { |r| r.summary_builder }, donate_count: current_user.donate_count})
  end

  def voucher_records
    donate_records = current_user.donate_records.paid.to_bill.sorted
    api_success(data: {donate_records: donate_records.map { |r| r.summary_builder }, donate_count: current_user.donate_count})
  end

end
