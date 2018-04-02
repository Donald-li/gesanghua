class Api::V1::CampsController < Api::V1::BaseController
  before_action :set_project, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def get_address_list
    api_success(data: Camp.address_group)
  end

  def applies_list
    @camp_applies = ProjectSeasonApply.where(project: Project.camp_project).raise_project.show.camp_raising.sorted
    total = @camp_applies.count
    @camp_applies = @camp_applies.where(camp_id: Camp.where(city: params[:city]).pluck(:id)) if params[:city].present?
    @camp_applies = @camp_applies.where(camp_id: Camp.where(district: params[:district]).pluck(:id)) if params[:district].present?
    @camp_applies = @camp_applies.page(params[:page]).per(params[:per])
    api_success(data: {camp_list: @camp_applies.collect{|item| item.summary_builder}, total: total, pagination: json_pagination(@camp_applies)})
  end

  def apply_camp
    @apply_camp = ProjectSeasonApply.find(params[:id])
    api_success(data: @apply_camp.detail_builder)
  end

  def member
    @apply_camp = ProjectSeasonApply.find(params[:id])
    @students = ProjectSeasonApplyCampStudent.where(apply: @apply_camp).joins(:apply_camp).where("project_season_apply_camps.execute_state = ?", 3).pass.sorted
    @teachers = ProjectSeasonApplyCampTeacher.where(apply: @apply_camp).joins(:apply_camp).where("project_season_apply_camps.execute_state = ?", 3).pass.sorted
    api_success(data: (@student + @teachers).map {|s| s.summary_builder})
  end

  private
  def set_project
    @project = Project.camp_project
  end
end
