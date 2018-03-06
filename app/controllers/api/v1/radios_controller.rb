class Api::V1::RadiosController < Api::V1::BaseController
  before_action :set_project, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def get_address_list
    api_success(data: ProjectSeasonApply.address_group(Project.radio_project.id))
  end

  def applies_list
    @radio_applies = ProjectSeasonApply.where(project: Project.radio_project).pass.show.sorted
    @radio_applies = @radio_applies.where(school_city: params[:city]) if params[:city].present?
    @radio_applies = @radio_applies.where(school_district: params[:district]) if params[:district].present?
    @radio_applies = @radio_applies.page(params[:page]).per(params[:per])
    api_success(data: {radio_list: @radio_applies.collect{|item| item.summary_builder}, pagination: json_pagination(@radio_applies)})
  end

  private
  def set_project
    @project = Project.radio_project
  end
end
