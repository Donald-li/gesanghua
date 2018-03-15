# 悦读项目申请
class Api::V1::GshPlus::ReadProjectAppliesController < Api::V1::BaseController
  # 准备一些基础数据

  def show
    @project = Project.find(params[:project_id])
    api_success(data: @project.detail_builder)
  end
end
