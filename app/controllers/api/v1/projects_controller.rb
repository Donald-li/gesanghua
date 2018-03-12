class Api::V1::ProjectsController < Api::V1::BaseController
  before_action :set_project, only: [:description]

  def index
    projects = Project.where(id: current_user.manage_projects.ids).sorted.visible
    api_success(data: projects.map{|p| p.summary_builder})
  end

  def description
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  private
  def set_project
    @project = Project.find_by(alias: params[:name])
  end
end
