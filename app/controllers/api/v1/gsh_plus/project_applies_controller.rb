# 项目申请
class Api::V1::GshPlus::ProjectAppliesController < Api::V1::BaseController

  def new
    @project = Project.find(params[:project_id])
    api_success(data: @project.detail_builder)
  end

  def show
    @project = Project.find(params[:project_id])
    api_success(data: @project.detail_builder)
  end

end
