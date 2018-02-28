class Api::V1::ChildrenGrantsController < Api::V1::BaseController
  before_action :set_pair, only: [:grants_list]

  def grants_list
    api_error(message: '无效页面') && return unless @pair
    api_success(data: {grants: @pair.gsh_child_grants.pending.reverse_sorted.map{|grant| grant.summary_builder}})
  end

  private

  def set_pair
    @pair = ProjectSeasonApplyChild.find(params[:id])
  end

end
