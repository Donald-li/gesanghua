class Api::V1::VisitReportsController < Api::V1::BaseController

  before_action :set_project, only: [:index]

  def index
    visit_reports = @project.project_reports.visit_report.show.sorted.page(params[:page]).per(params[:per_page])
    api_success(data: {visit_reports: visit_reports.map { |r| r.detail_builder }, pagination: json_pagination(visit_reports)})
  end

  private
  def set_project
    @project = Project.first #find(params[:project_id])
  end

end
