class Api::V1::PairsController < Api::V1::BaseController
  before_action :set_pair, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @pair
    api_success(data: @pair.detail_builder)
  end

  private
  def set_pair
    @pair = Project.first
  end
end
