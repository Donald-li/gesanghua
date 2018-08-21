class Site::ReportsController < Site::BaseController
  before_action :set_project, only: :index
  def index
    @search = @project.project_reports.where(kind: params[:kind]).ransack(params[:q])
    scope = @search.result.show.sorted
    @reports = scope.page(params[:page])
  end

  def show
    @report = ProjectReport.find(params[:id])
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end
end
