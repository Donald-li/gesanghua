class Api::V1::DonateRecordsController < Api::V1::BaseController
  skip_before_action :login?

  def index
    if params[:type] == 'child'
      donate_records = DonateRecord.where(gsh_child: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:type] == 'read'
      donate_records = DonateRecord.where(project_season_apply_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:type] == 'radio'
      donate_records = DonateRecord.where(project_season_apply_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:type] == 'teamDonate'
      donate_records = DonateRecord.where(team_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:type] == 'camp'
      donate_records = DonateRecord.where(project_season_apply_id: params[:item_id]).sorted.page(params[:page]).per(7)
    elsif params[:project_id].present?
      donate_records = DonateRecord.where(project_id: params[:project_id]).sorted.page(params[:page]).per(7)
    else
      donate_records = DonateRecord.sorted.page(params[:page]).per(7)
    end
    api_success(data: {donate_records: donate_records.map { |r| r.detail_builder }, pagination: json_pagination(donate_records)})
  end

  def show
    api_success(data: {donate_record: DonateRecord.find(params[:id]).detail_builder})
  end

end
