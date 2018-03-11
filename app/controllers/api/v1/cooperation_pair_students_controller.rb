class Api::V1::CooperationPairStudentsController < Api::V1::BaseController

  def index
    @apply = ProjectSeasonApply.find_by(id: params[:id])
    if @apply.blank?
      school = current_user.teacher.school
      @apply = ProjectSeasonApply.show.raising.where('number > 0').where(project_id: Project.pair_project.try(:id)).where(school_id: school.id).sorted.last
    end
    apply_students = @apply.children.sorted.page(params[:page]).per(params[:per])
    api_success(data: {apply_students: apply_students.map { |r| r.list_builder }, pagination: json_pagination(apply_students)})
  end

  def new

  end

  def create
    apply = ProjectSeasonApply.find(params[:apply_id])
    school_id = apply.school_id
    season_id = apply.project_season_id
    project_id = apply.project_id
    nation = params[:nation].first if params[:nation]
    level = params[:level].first if params[:level]
    grade = params[:grade].first if params[:grade]
    semester = params[:semester].first if params[:semester]

    @student = ProjectSeasonApplyChild.new(
      project_season_apply_id: apply.id,
      school_id: school_id,
      project_season_id: season_id,
      project_id: project_id,
      name: params[:name],
      id_card: params[:id_card],
      nation: nation,
      level: level,
      grade: grade,
      semester: semester,
      teacher_name: params[:teacher_name],
      teacher_phone: params[:teacher_phone],
      description: params[:description],
      father: params[:father],
      father_job: params[:father_job],
      mother: params[:mother],
      mother_job: params[:mother_job],
      guardian: params[:guardian],
      guardian_relation: params[:guardian_relation],
      guardian_phone: params[:guardian_phone],
      address: params[:address],
      family_income: params[:family_income],
      family_expenditure: params[:family_expenditure],
      income_source: params[:income_source],
      family_condition: params[:family_condition],
      brothers: params[:brothers],
      province: apply.province,
      city: apply.city,
      district: apply.district
    )
    if @student.save
      @student.count_age
      @student.attach_avatar(params[:avatar][:id]) if params[:avatar].present?
      @student.attach_id_image(params[:id_image][0][:id]) if params[:id_image][0].present?
      @student.attach_residence(params[:residence][0][:id]) if params[:residence][0].present?
      @student.attach_poverty(params[:poverty][0][:id]) if params[:poverty][0].present?
      @student.attach_family_image(params[:family_image][0][:id]) if params[:family_image][0].present?
      api_success(data: {result: true, apply_id: @student.project_season_apply_id}, message: '孩子信息提交成功！')
    else
      api_success(data: {result: false}, message: '孩子信息提交失败，请重试！')
    end
  end

  def edit
    @student = ProjectSeasonApplyChild.find(params[:id])
    api_success(data: {student: @student.whole_builder})
  end

  def update
    @student = ProjectSeasonApplyChild.find(params[:student_id])
    nation = params[:nation].first if params[:nation]
    level = params[:level].first if params[:level]
    grade = params[:grade].first if params[:grade]
    semester = params[:semester].first if params[:semester]
    if @student.update(
        name: params[:name],
        id_card: params[:id_card],
        nation: nation,
        level: level,
        grade: grade,
        semester: semester,
        teacher_name: params[:teacher_name],
        teacher_phone: params[:teacher_phone],
        description: params[:description],
        father: params[:father],
        father_job: params[:father_job],
        mother: params[:mother],
        mother_job: params[:mother_job],
        guardian: params[:guardian],
        guardian_relation: params[:guardian_relation],
        guardian_phone: params[:guardian_phone],
        address: params[:address],
        family_income: params[:family_income],
        family_expenditure: params[:family_expenditure],
        income_source: params[:income_source],
        family_condition: params[:family_condition],
        brothers: params[:brothers]
      )
      @student.count_age
      @student.attach_avatar(params[:avatar][:id]) if params[:avatar].present?
      @student.attach_id_image(params[:id_image][0][:id]) if params[:id_image][0].present?
      @student.attach_residence(params[:residence][0][:id]) if params[:residence][0].present?
      @student.attach_poverty(params[:poverty][0][:id]) if params[:poverty][0].present?
      @student.attach_family_image(params[:family_image][0][:id]) if params[:family_image][0].present?
      api_success(data: {result: true, apply_id: @student.project_season_apply_id}, message: '孩子信息提交成功！')
    else
      api_success(data: {result: false}, message: '孩子信息提交失败，请重试！')
    end
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
    api_success(data: {pair_records: children.map{|child| child.granted_record_builder}, child_info: gsh_child.child_info_builder})
  end

end
