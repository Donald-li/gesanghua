class Api::V1::DonateRecordsController < Api::V1::BaseController
  skip_before_action :login?

  def index
    if params[:type] == 'child'
      donate_records = DonateRecord.normal.where(project_season_apply_child_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:type] == 'read'
      donate_records = DonateRecord.normal.where(project_season_apply_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:type] == 'teamDonate'
      donate_records = DonateRecord.normal.where(team_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:type] == 'camp'
      donate_records = DonateRecord.normal.where(project_season_apply_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:item_id].present?
      donate_records = DonateRecord.normal.where(project_season_apply_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:project_id].present?
      donate_records = DonateRecord.normal.where(project_id: params[:project_id]).sorted.page(params[:page]).per(7)
    else
      donate_records = DonateRecord.normal.sorted.page(params[:page]).per(7)
    end
    api_success(data: {donate_records: donate_records.map { |r| r.summary_builder}, pagination: json_pagination(donate_records)})
  end

  def show
    api_success(data: {donate_record: DonateRecord.find(params[:id]).summary_builder})
  end

end
