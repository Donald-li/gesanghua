class Api::V1::CooperationPairsController < Api::V1::BaseController
  before_action :set_pair, only: [:index]

  def index
    # byebug
    api_error(message: '无效项目') && return unless @pair
    # user = User.find_by(auth_token: params)
    api_success(data: @pair.detail_builder)
  end

  private
  def set_pair
    @pair = Project.first
  end
end
