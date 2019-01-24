class Site::GoodsController < Site::BaseController
  before_action :set_project, only: [:index, :show]

  def detail
    @apply = ProjectSeasonApply.find(params[:id])
    @feedbacks = Feedback.show.recommend.sorted.where(project_season_apply_id: @apply.id)
    @donate_records = DonateRecord.normal.where(project_season_apply_id: @apply.id).sorted.page(1).per(6)
  end

  def index
    @total = ProjectSeasonApply.where(project: @project).show.raising.raise_project.pass.sorted.count
    scope = ProjectSeasonApply.where(project: @project).show.raising.raise_project.pass.sorted
    scope = scope.where("name like :q", q: "%#{params[:name]}%") if params[:name].present?
    @applies = scope.page(params[:page]).per(12)
  end

  def show
    @total = ProjectSeasonApply.where(project: @project).show.raising.raise_project.pass.sorted.count
    @project_reports = @project.project_reports.project_report.show.sorted.limit(15)
    @donate_records = DonateRecord.normal.where(project: @project).sorted.page(1).per(6)
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

end
