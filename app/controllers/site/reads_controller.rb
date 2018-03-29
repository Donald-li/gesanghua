class Site::ReadsController < Site::BaseController

  def index
    @project = Project.read_project

    @book_applies = ProjectSeasonApply.where(project: @project).show.raise_project.read_executing.pass.sorted
    @total = @book_applies.count

    @seach = ProjectSeasonApply.where(project: @project).show.raise_project.read_executing.pass.sorted.ransack(params[:q])
    scope = @seach.result
    @applies = scope.page(params[:page])
  end

  def show
    @project = Project.read_project

    @project_report = @project.project_reports.project_report.show.sorted
  end

end
