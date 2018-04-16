class Api::V1::Account::DonateRecordsController < Api::V1::BaseController

  def index
    donations = current_user.donations.paid.where.not(project_id: nil).sorted.page(params[:page]).per(params[:per])
    donations = donations.where(project_id: params[:project_id].to_i) if params[:project_id].present? && params[:project_id] != 'all'
    api_success(data: {donate_records: donations.map { |r| r.detail_builder }, pagination: json_pagination(donations)})
  end

  def projects
    api_success(data: Project.sorted.map { |p| {id: p.id, name: p.name} })
  end

  def record_details
    donation = Donation.find(params[:id])
    api_success(data: donation.detail_builder)
  end

  def account_records
    donate_records = current_user.donate_records.sorted
    api_success(data: {donate_records: donate_records.map { |r| r.detail_builder }, donate_count: current_user.donate_count})
  end

  def voucher_records
    donate_records = current_user.donations.to_bill.sorted
    api_success(data: {donate_records: donate_records.map { |r| r.summary_builder }, donate_count: current_user.donate_count})
  end

end
