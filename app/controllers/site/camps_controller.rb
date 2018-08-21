class Site::CampsController < Site::BaseController

  def index
    @project = Project.camp_project
    @search = ProjectSeasonApply.where(project: @project).ransack(params[:q])
    scope = @search.result
    scope = scope.where("name like :q", q: "%#{params[:name]}%") if params[:name].present?
    scope = scope.where(camp_id: params[:camp_id]) if params[:camp_id].present?
    @applies = scope.raise_project.show.camp_raising.sorted
    @total = @applies.count
    @applies = @applies.page(params[:page]).per(12)
  end

  def show
    @project = Project.camp_project
    @applies = ProjectSeasonApply.where(project: @project).raise_project.show.camp_raising.sorted
    @total = @applies.count
    @project_reports = @project.project_reports.project_report.show.sorted.limit(15)
    @donate_records = DonateRecord.normal.where(project: @project).sorted.page(1).per(6)
  end

  def detail
    @apply = ProjectSeasonApply.find(params[:id])
    @feedbacks = @apply.continual_feedbacks.recommend.sorted
    @donate_records = DonateRecord.normal.where(project_season_apply_id: @apply.id).sorted.page(1).per(6)
  end

end
