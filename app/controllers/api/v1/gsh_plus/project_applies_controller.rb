# 项目申请
class Api::V1::GshPlus::ProjectAppliesController < Api::V1::BaseController

  # # 新增申请：学校或教师
  # def new
  #   # 如果是校长，查看全部, 如果是老师，看自己负责的
  #   role = current_user.is_school_headmaster?
  #   project_ids = if role == 'headmaster'
  #     Project.visible.ids
  #   elsif role == 'teacher'
  #     current_user.teacher.projects.visible.ids
  #   else
  #     []
  #   end
  #   # 一对一如果没有被分配名额，提示
  #   school = current_user.teacher.school
  #   has_pair_apply = true#ProjectSeasonApply.show.raising.where('number > 0').where(project_id: Project.pair_project.try(:id)).where(school_id: school.id).exists?
  #   has_comp_apply = true#ProjectSeasonApply.show.raising.where('number > 0').where(project_id: Project.camp_project.try(:id)).where(school_id: school.id).exists?
  #   api_success(data: {project_ids: project_ids, has_pair_apply: has_pair_apply, has_comp_apply: has_comp_apply}.camelize_keys!)
  # end

  def new
    @project = Project.find(params[:project_id])
    api_success(data: @project.detail_builder)
  end

  def show
    @project = Project.find(params[:project_id])
    api_success(data: @project.detail_builder)
  end

end
