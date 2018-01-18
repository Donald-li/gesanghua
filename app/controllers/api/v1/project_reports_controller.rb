class Api::V1::ProjectReportsController < Api::V1::BaseController
  before_action :set_project, only: [:index]

  def index
    project_reports = @project.project_reports.sorted.page(params[:page])
    api_success(data: {reports: project_reports.map { |r| r.detail_builder }, pagination: json_pagination(project_reports)})
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end
end
