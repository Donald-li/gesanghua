class Api::V1::Cooperation::CampMembersController < Api::V1::BaseController
  before_action :set_apply_camp

  def index
    students = @apply_camp.camp_members.student.sorted
    teachers = @apply_camp.camp_members.teacher.sorted
    api_success(data: {students: students.map{|st| st.summary_builder}, teachers: teachers.map{|t| t.summary_builder}} )
  end

  def students
    students = @apply_camp.camp_members.student.page(params[:page]).per(params[:per])
    api_success(data: {students: students.map{|st| st.summary_builder}, pagination: json_pagination(students)})
  end

  def teachers
    teachers = @apply_camp.camp_members.teacher.page(params[:page]).per(params[:per])
    api_success(data: {teachers: teachers.map{|t| t.summary_builder}, pagination: json_pagination(teachers)} )
  end

  def create
    @member = ProjectSeasonApplyCampMember.new(member_params.except(:image).merge(camp: @apply_camp.camp, school: @apply_camp.school, apply: @apply_camp.apply))
    if @member.save
      @member.attach_image(params[:image][:id])
      api_success(data: {result: true, camp_id: @apply_camp.id}, message: '提交成功' )
    else
      api_success(data: {result: false}, message: '提交失败，请重试' )
    end
  end

  def edit
    @member = ProjectSeasonApplyCampMember.find(params[:id])
    api_success(data: @member.detail_builder)
  end

  def update
    @member = ProjectSeasonApplyCampMember.find(params[:id])
    if @member.update(member_params)
      @member.attach_image(params[:image][:id])
      api_success(data: {result: true, camp_id: @apply_camp.id}, message: '提交成功' )
    else
      api_success(data: {result: false}, message: '提交失败，请重试' )
    end
  end

  private
  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:camp_id])
  end

  def member_params
    params.require(:camp_member).permit!
  end

end