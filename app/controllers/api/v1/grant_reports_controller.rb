class Api::V1::GrantReportsController < Api::V1::BaseController

  before_action :set_project, only: [:index]

  def index
    grant_reports = @project.project_reports.grant_report.show.sorted.page(params[:page]).per(params[:per_page])
    api_success(data: {grant_reports: grant_reports.map { |r| r.detail_builder }, pagination: json_pagination(grant_reports)})
  end

  private
  def set_project
    @project = Project.first #find(params[:project_id])
  end

end
