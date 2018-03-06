class Api::V1::FlowersController < Api::V1::BaseController
  before_action :set_project, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def get_address_list
    api_success(data: ProjectSeasonApply.address_group(Project.care_project.id))
  end

  def applies_list
    @flower_applies = ProjectSeasonApply.where(project: Project.care_project).pass.show.sorted
    @flower_applies = @flower_applies.where(school_city: params[:city]) if params[:city].present?
    @flower_applies = @flower_applies.where(school_district: params[:district]) if params[:district].present?
    @flower_applies = @flower_applies.page(params[:page]).per(params[:per])
    api_success(data: {flower_list: @flower_applies.collect{|item| item.summary_builder}, pagination: json_pagination(@flower_applies)})
  end

  private
  def set_project
    @project = Project.care_project
  end
end
