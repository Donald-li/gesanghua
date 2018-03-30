class Site::ReadsController < Site::BaseController

  def index
    @project = Project.read_project
    @book_applies = ProjectSeasonApply.where(project: @project).show.raise_project.read_executing.pass.sorted
    @total = @book_applies.count
    scope = ProjectSeasonApply.where(project: @project).show.raise_project.read_executing.pass.sorted
    scope = scope.where(bookshelf_type: params[:type]) if params[:type].present?
    scope = scope.where("name like :q", q: "%#{params[:name]}%") if params[:name].present?
    @applies = scope.page(params[:page]).per(12)
  end

  def show
    @project = Project.read_project
    @book_applies = ProjectSeasonApply.where(project: @project).show.raise_project.read_executing.pass.sorted
    @total = @book_applies.count
    @project_reports = @project.project_reports.project_report.show.sorted
    @donate_records = DonateRecord.where(project: @project).paid.sorted
  end

  def detail
    @apply = ProjectSeasonApply.find(params[:id])
    @feedbacks = Feedback.show.sorted.where(project_season_apply_id: @apply.id)
    @donate_records = DonateRecord.where(project_season_apply_id: @apply.id)
  end

end
