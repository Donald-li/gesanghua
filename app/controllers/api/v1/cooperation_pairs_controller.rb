class Api::V1::CooperationPairsController < Api::V1::BaseController
  before_action :set_pair, only: [:index]

  def index
    user = current_user
    # 校长或者教师的项目申请
    if user.headmaster?
      applies = user.school.project_season_applies.where(project_id: @pair.id).includes(:season).sorted.page(params[:page]).per(params[:per])
      api_success(data: {applies: applies.map { |r| r.pair_applies_builder }, pagination: json_pagination(applies)})
    elsif user.teacher?
      applies = user.teacher.school.project_season_applies.where(project_id: @pair.id).includes(:season).sorted.page(params[:page]).per(params[:per])
      api_success(data: {applies: applies.map { |r| r.pair_applies_builder }, pagination: json_pagination(applies)})
    else
      api_success(data: {applies: [], pagination: json_pagination([])})
    end
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    api_success(data: @apply.detail_builder)
  end

  def verified_students
    apply = ProjectSeasonApply.find(params[:id])
    students = apply.children.pass
    students = students.where("name like :q or id_card like :q", q: "%#{params[:keyword]}%") if params[:keyword].present?
    students = students.page(params[:page]).per(params[:per])
    api_success(data: {students: students.map{|st| st.manage_list_builder}, apply_name: apply.apply_name, pagination: json_pagination(students)})
  end

  def submit_students
    apply = ProjectSeasonApply.find(params[:id])
    students = apply.children
    students = students.where("name like :q or id_card like :q", q: "%#{params[:keyword]}%") if params[:keyword].present?
    students = students.page(params[:page]).per(params[:per])
    api_success(data: {submit_students: students.submit.map{|st| st.manage_list_builder}, draft_students: students.draft.map{|st| st.manage_list_builder}, apply_name: apply.apply_name})
  end

  private
  def set_pair
    @pair = Project.first
  end
end
