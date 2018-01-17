class Api::V1::ProjectsController < Api::V1::BaseController
  before_action :set_project, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project)
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end
end
