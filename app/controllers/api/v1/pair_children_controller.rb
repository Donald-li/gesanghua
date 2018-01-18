class Api::V1::PairChildrenController < Api::V1::BaseController
  before_action :set_pair, only: [:show]

  def show
    api_error(message: '无效页面') && return unless @pair
    api_success(data: @pair.summary_builder)
  end

  private

  def set_pair
    @pair = ProjectSeasonApplyChild.find(params[:id])
  end

end
