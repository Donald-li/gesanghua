class Site::GoodsController < Site::BaseController

  def detail
    @apply = ProjectSeasonApply.find(params[:id])
    @feedbacks = Feedback.show.sorted.where(project_season_apply_id: @apply.id)
    @donate_records = DonateRecord.where(project_season_apply_id: @apply.id)
  end

  def index
    if params[:type] == 'care'
      @project = Project.care_project
    elsif params[:type] == 'radio'
      @project = Project.radio_project
    end
    @total = ProjectSeasonApply.where(project: @project).show.raising.raise_project.pass.sorted.count
    scope = ProjectSeasonApply.where(project: @project).show.raising.raise_project.pass.sorted
    scope = scope.where("name like :q", q: "%#{params[:name]}%") if params[:name].present?
    @applies = scope.page(params[:page]).per(12)
  end

  def show
    if params[:id] == 'care'
      @project = Project.care_project
    elsif params[:id] == 'radio'
      @project = Project.radio_project
    end
    @total = ProjectSeasonApply.where(project: @project).show.raising.raise_project.pass.sorted.count
    @project_reports = @project.project_reports.project_report.show.sorted
    @donate_records = DonateRecord.where(project: @project).paid.sorted
  end

end
