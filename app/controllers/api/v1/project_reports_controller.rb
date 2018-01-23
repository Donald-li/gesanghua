class Api::V1::ProjectReportsController < Api::V1::BaseController
  before_action :set_project, only: [:index]

  def index
    # byebug
    project_reports = @project.project_reports.project_report.show.sorted.page(params[:page]).per(params[:per_page])
    api_success(data: {project_reports: project_reports.map { |r| r.detail_builder }, pagination: json_pagination(project_reports)})
  end

  private
  def set_project
    @project = Project.first #find(params[:project_id])
  end
end
