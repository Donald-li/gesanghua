class Api::V1::Cooperation::CampMembersController < Api::V1::BaseController
  before_action :set_apply_camp, only: [:index, :students, :teachers, :create, :edit, :update, :qrcode]
  before_action :set_member, only: [:edit, :update, :edit_reason, :update_reason]

  def index
    students = @apply_camp.camp_members.student.draft.sorted
    teachers = @apply_camp.camp_members.teacher.draft.sorted
    api_success(data: {students: students.map {|st| st.summary_builder}, teachers: teachers.map {|t| t.summary_builder}})
  end

  def students
    students = @apply_camp.camp_members.student.draft.sorted.page(params[:page]).per(params[:per])
    api_success(data: {students: students.map {|st| st.summary_builder}, pagination: json_pagination(students)})
  end

  def teachers
    teachers = @apply_camp.camp_members.teacher.draft.sorted.page(params[:page]).per(params[:per])
    api_success(data: {teachers: teachers.map {|t| t.summary_builder}, pagination: json_pagination(teachers)})
  end

  def create
    @member = ProjectSeasonApplyCampMember.new(member_params.except(:image).merge(camp: @apply_camp.camp, school: @apply_camp.school, apply: @apply_camp.apply, state: 'draft'))
    if ProjectSeasonApplyCampMember.allow_apply?(@apply_camp, member_params[:id_card])
      if @member.save
        @member.attach_image(params[:image][:id]) if params[:image].present?
        api_success(data: {result: true, camp_id: @apply_camp.id}, message: '提交成功')
      else
        api_success(data: {result: false}, message: '提交失败，请重试')
      end
    else
      api_error(message: '身份证号已占用')
    end
  end

  def edit
    api_success(data: @member.detail_builder)
  end

  def update
    if ProjectSeasonApplyCampMember.allow_apply?(@apply_camp, member_params[:id_card], @member)
      if @member.update(member_params)
        @member.attach_image(params[:image][:id]) if params[:image].present?
        api_success(data: {result: true, camp_id: @apply_camp.id}, message: '提交成功')
      else
        api_success(data: {result: false}, message: '提交失败，请重试')
      end
    else
      api_error(message: '身份证号已占用')
    end
  end

  def qrcode
    url = "#{Settings.m_root_url}/form/link-to-visit?type=camp_member&kind=#{params[:kind]}&id=#{@apply_camp.id}"
    api_success(data: {qrcode_url: url})
  end

  def edit_reason
    api_success(data: @member.reason)
  end

  def update_reason
    if @member.update(reason: params[:reason])
      api_success(data: {result: true}, message: '提交成功')
    else
      api_success(data: {result: false}, message: '提交失败，请重试')
    end
  end

  private
  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:camp_id])
  end

  def member_params
    params.require(:camp_member).permit!
  end

  def set_member
    @member = ProjectSeasonApplyCampMember.find(params[:id])
  end

end
