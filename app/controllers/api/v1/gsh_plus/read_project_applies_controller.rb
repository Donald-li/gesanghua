# 悦读项目申请
class Api::V1::GshPlus::ReadProjectAppliesController < Api::V1::BaseController
  # 准备一些基础数据
  def new
    user = current_user
    @school = user.teacher.school
    @seasons = Project.read_project.seasons.enable.all
    api_success(data: {seasons: @seasons.map{|s| {name: s.name, value: s.id.to_s}}, school: {id: @school.id, name: @school.name}})
  end

  def show
    @project = Project.find(params[:project_id])
    api_success(data: @project.detail_builder)
  end
end
