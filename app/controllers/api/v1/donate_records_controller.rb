class Api::V1::DonateRecordsController < Api::V1::BaseController

  def index
    donate_records = DonateRecord.where(project_id: params[:project_id]).sorted.page(params[:page])
    api_success(data: {donate_records: donate_records.map { |r| r.detail_builder }, pagination: json_pagination(donate_records)})
  end

end
