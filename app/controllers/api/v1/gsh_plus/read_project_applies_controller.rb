# 悦读项目申请
class Api::V1::GshPlus::ReadProjectAppliesController < Api::V1::BaseController
  # 准备一些基础数据
  def new
    user = current_user
    @school = user.teacher.school
    @seasons = Project.read_project.seasons.enable.all
    @school = current_user.teacher.school
    @class = @school.bookshelves.done
    api_success(data: {seasons: @seasons.map{|s| {name: s.name, value: s.id.to_s}}, school: @school.apply_builder, class_list: @class.map { |c| {name: c.classname, value: c.id.to_s} }})
  end

  def show
    @project = Project.find(params[:project_id])
    api_success(data: @project.detail_builder)
  end
end
