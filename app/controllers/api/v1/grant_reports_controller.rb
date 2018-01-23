class Api::V1::GrantReportsController < Api::V1::BaseController

  def index
    grant_reports = GshChildGrant.granted.sorted.page(params[:page]).per(params[:per_page])
    api_success(data: {grant_reports: grant_reports.map { |r| r.detail_builder }, pagination: json_pagination(grant_reports)})
  end

end
