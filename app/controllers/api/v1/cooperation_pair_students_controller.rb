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
    url = "http://localhost:8080/cooperation/cooperation-school-one-apply/#{@apply.id}/apply-students/new?user=#{user}&school=#{school}"
    api_success(data: {qrcode_url: url})
  end

  def edit
    @student = ProjectSeasonApplyChild.find(params[:id])
    api_success(data: {apply_student: @student.list_builder})
  end

  def update
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

  def checked_list
    @apply = ProjectSeasonApply.find(params[:id])
    students = @apply.children.pass.sorted.page(params[:page]).per(params[:per])
    api_success(data: {students: students.map { |r| r.list_builder }, pagination: json_pagination(students)})
  end

end
