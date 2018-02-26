class Api::V1::Account::DonateRecordsController < Api::V1::BaseController

  def index
    donate_records = current_user.donate_records.sorted.page(params[:page]).per(params[:per])
    api_success(data: {donate_records: donate_records.map { |r| r.detail_builder }, pagination: json_pagination(donate_records)})
  end

end
