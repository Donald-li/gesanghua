class Site::PairsController < Site::BaseController
  before_action :login_require, only: :detail

  def index
    @project = Project.pair_project
    @total = ProjectSeasonApplyChild.where(project: @project).show.outside.pass.sorted.count
    @address_list = ProjectSeasonApplyChild.city_group
    scope = ProjectSeasonApplyChild.show.pass.outside.sorted
    scope = scope.where("name like :q", q: "%#{params[:name]}%") if params[:name].present?
    scope = scope.where(city: params[:city]) if params[:city].present?
    @children = scope.page(params[:page]).per(8)
  end

  def show
    @project = Project.pair_project
    @total = ProjectSeasonApplyChild.where(project: @project).show.outside.pass.sorted.count
    @project_reports = @project.project_reports.project_report.show.sorted.limit(15)
    @visit_reports = @project.project_reports.visit_report.show.sorted.limit(15)
    @grant_reports = @project.project_reports.grant_report.show.sorted.limit(15)
    @donate_records = DonateRecord.normal.where(project: @project).sorted.page(1).per(6)
  end

  def detail
    @child = ProjectSeasonApplyChild.find(params[:id])
    @gsh_child_grants = @child.donate_pending_records.reverse
    @grants = @child.gsh_child_grants.granted.reverse_sorted
    @donate_records = DonateRecord.normal.where(project_season_apply_child_id: @child.id).sorted.page(1).per(6)
  end

  def batch
    if params[:type] == 'continue'
      apply_child_ids = current_user.donate_records.visible.pluck(:project_season_apply_child_id)
      apply_child_ids = apply_child_ids.push(ProjectSeasonApplyChild.where(priority_id: current_user.id).pluck(:id)).flatten.uniq
      scope = ProjectSeasonApplyChild.where(id: apply_child_ids).pass.outside.sorted
      @children = scope
    else
      @project = Project.pair_project
      scope = ProjectSeasonApplyChild.show.pass.outside.sorted
      @children = scope
    end

  end

  def batch_donate
  end

end
