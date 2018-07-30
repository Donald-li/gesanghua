class Api::V1::ProjectsController < Api::V1::BaseController
  before_action :set_project, only: [:description]
  def index
    scope = Project.includes(:donate_item)
    scope = current_user.manage_projects if params[:type] == 'manage'
    scope = scope.goods if params[:type] == 'goods'
    scope = scope.donate if params[:type] == 'donate'
    projects = scope.sorted
    api_success(data: projects.map{|p| p.summary_builder})
  end

  def description
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def donate_project
    @project = Project.find(params[:id])
    api_success(data: @project.detail_builder)
  end

  private
  def set_project
    if params[:name].to_s =~ /^\d+$/
      @project = Project.find_by(id: params[:name])
    else
      @project = Project.find_by(alias: params[:name])
    end
  end
end
