class Api::V1::CooperationPairStudentsController < Api::V1::BaseController
  before_action :set_apply, only: [:index]

  def index
    apply_students = @apply.children.sorted.page(params[:page]).per(params[:per])
    api_success(data: {apply_students: apply_students.map { |r| r.list_builder }, pagination: json_pagination(apply_students)})
  end

  private
  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end
end
