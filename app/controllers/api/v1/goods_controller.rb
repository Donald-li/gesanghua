class Api::V1::GoodsController < Api::V1::BaseController
  before_action :set_project

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def get_address_list
    api_success(data: ProjectSeasonApply.address_group(@project.id))
  end

  def applies_list
    @applies = ProjectSeasonApply.where(project: @project).show.raising.raise_project.pass.sorted
    total = @applies.count
    @applies = @applies.where(school_id: School.where(city: params[:city]).pluck(:id)) if params[:city].present?
    @applies = @applies.where(school_id: School.where(district: params[:district]).pluck(:id)) if params[:district].present?
    @applies = @applies.page(params[:page]).per(params[:per])
    api_success(data: {list: @applies.collect{|item| item.summary_builder}, total: total, pagination: json_pagination(@applies)})
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end
end
