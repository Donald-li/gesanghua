class Site::DonateProjectsController < Site::BaseController
  before_action :set_project, only: [:show]

  def show
    @project_reports = @project.project_reports.project_report.show.sorted
    @donate_records = DonateRecord.normal.where(project: @project).sorted.page(1).per(6)
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

end
