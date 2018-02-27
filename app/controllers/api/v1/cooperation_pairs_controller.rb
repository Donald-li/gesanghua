class Api::V1::CooperationPairsController < Api::V1::BaseController
  before_action :set_pair, only: [:index]

  def index
    # byebug
    user = User.find_by(auth_token: params[:auth_token])
    # 校长或者教师的项目申请
    if user.has_role?(:headmaster) && user.school.present?
      applies = user.school.project_season_applies.where(project_id: @pair.id).sorted.page(params[:page]).per(12)
      api_success(data: {applies: applies.map { |r| r.pair_applies_builder }, pagination: json_pagination(applies)})
    elsif user.has_role?(:teacher) && user.teacher?
      applies = user.teacher.project_season_applies.where(project_id: @pair.id).sorted.page(params[:page]).per(12)
      api_success(data: {applies: applies.map { |r| r.pair_applies_builder }, pagination: json_pagination(applies)})
    else
      api_success(data: [])
    end
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    api_success(data: @apply.detail_builder)
  end

  private
  def set_pair
    @pair = Project.first
  end
end
