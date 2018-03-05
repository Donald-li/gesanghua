class Api::V1::CooperationPairStudentsController < Api::V1::BaseController

  def index
    @apply = ProjectSeasonApply.find(params[:id])
    apply_students = @apply.children.sorted.page(params[:page]).per(params[:per])
    api_success(data: {apply_students: apply_students.map { |r| r.list_builder }, pagination: json_pagination(apply_students)})
  end

  def qrcode
    user = current_user.id
    @apply = ProjectSeasonApply.find(params[:id])
    school = @apply.school.id
    url = "http://#{Settings.app_host}/cooperation/student-apply?type=student_apply&id=#{@apply.id}&user=#{user}&school=#{school}"
    api_success(data: {qrcode_url: url})
  end

  def edit_reason
    @student = ProjectSeasonApplyChild.find(params[:id])
    api_success(data: {apply_student: @student.list_builder})
  end

  def update_reason
    @student = ProjectSeasonApplyChild.find(params[:id])
    if @student.update_attributes(
      reason: params[:cooperation_pair_student][:reason]
    )
      api_success
    else
      return api_error(message: @student.errors.full_messages.join("\n"))
    end
  end

  def submit_list
    @apply = ProjectSeasonApply.find(params[:id])
    @students = ProjectSeasonApplyChild.where("id in (?)", params[:students])
    if @students.update_all(approve_state: 1) && @apply.update(pair_state: 2)
      api_success
    else
      return api_error(message: "提交失败，请检查")
    end
  end

  def get_school
    @apply = ProjectSeasonApply.find(params[:id])
    school = @apply.school.name
    api_success(data: {school_name: school})
  end

  def checked_list
    @apply = ProjectSeasonApply.find(params[:id])
    students = @apply.children.pass.sorted.page(params[:page]).per(params[:per])
    api_success(data: {students: students.map { |r| r.list_builder }, pagination: json_pagination(students)})
  end

  def child_grants
    gsh_child = GshChild.find(params[:id])
    children = gsh_child.project_season_apply_children.where(project: Project.pair_project)
    api_success(data: {pair_records: children.map{|child| child.donate_record_builder}, child_info: gsh_child.child_info_builder})
  end

end
