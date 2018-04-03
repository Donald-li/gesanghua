class Api::V1::Cooperation::CampsController < Api::V1::BaseController
  before_action :set_camp, only: [:index]
  before_action :set_apply_camp, only: [:show, :verified_members]

  def index
    user = current_user
    # 校长或者教师的项目申请
    if user.headmaster?
      applies = user.school.apply_camps.sorted.page(params[:page]).per(params[:per])
      api_success(data: {applies: applies.map { |r| r.camp_applies_builder }, pagination: json_pagination(applies)})
    elsif user.teacher?
      applies = user.teacher.apply_camps.sorted.page(params[:page]).per(params[:per])
      api_success(data: {applies: applies.map { |r| r.camp_applies_builder }, pagination: json_pagination(applies)})
    else
      api_success(data: {applies: [], pagination: json_pagination([])})
    end
  end

  def show
    api_success(data: @apply_camp.detail_builder)
  end

  def verified_members
    students = @apply_camp.camp_members.student.pass.page(params[:page]).per(params[:per])
    teachers = @apply_camp.camp_members.teacher.pass.page(params[:page]).per(params[:per])
    api_success(data: {students: students.map{|st| st.summary_builder}, teachers: teachers.map{|t| t.summary_builder}, pagination_student: json_pagination(students), pagination_teacher: json_pagination(teachers)} )
  end

  def submit

  end

  private
  def set_camp
    @camp = Project.camp_project
  end

  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:id])
  end

end