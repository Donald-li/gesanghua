class Api::V1::DonateRecordsController < Api::V1::BaseController

  def index
    if params[:type] == 'child'
      donate_records = DonateRecord.where(project_season_apply_child_id: params[:item_id]).sorted.page(params[:page]).per(7)
    # elsif params[:type] == 'project' ?
    #   donate_records = DonateRecord.where(project_id: params[:item_id]).sorted.page(params[:page]).per(7)
    else
      donate_records = DonateRecord.sorted.page(params[:page]).per(7)
    end
    api_success(data: {donate_records: donate_records.map { |r| r.detail_builder }, pagination: json_pagination(donate_records)})
  end

  def certificate
    if params[:donate_method] == 'monthDonate'
      record = MonthDonate.find(params[:id])
      api_success(data: record.certificate_builder)
    else
      record = DonateRecord.find(params[:id])
      api_success(data: record.certificate_builder)
    end
  end

end
