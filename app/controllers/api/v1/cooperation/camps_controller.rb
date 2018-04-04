class Api::V1::Cooperation::CampsController < Api::V1::BaseController
  before_action :set_camp, only: [:index]
  before_action :set_apply_camp, only: [:show, :verified_members, :submit]

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
    member = @apply_camp.camp_members.pass.page(params[:page]).per(params[:per])
    api_success(data: {member: member.map{|st| st.summary_builder}, apply_name: @apply_camp.apply.try(:apply_name), pagination: json_pagination(member)} )
  end

  def submit
    if ProjectSeasonApplyCampMember.where(id: params[:member_ids]).update(state: 'submit') && @apply_camp.to_approve!
      api_success(data: {result: true}, message: '提交成功' )
    else
      api_success(data: {result: false}, message: '提交失败，请重试' )
    end
  end

  private
  def set_camp
    @camp = Project.camp_project
  end

  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:id])
  end

end