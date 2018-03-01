class Api::V1::Staff::GrantsController < Api::V1::BaseController

  before_action :set_batch
  before_action :set_grant, only: [:show]

  def index
    search = @batch.grants.search(params[:q])
    grants = search.result.sorted.page(params[:page])
    api_success(data: {grants: grants.map { |r| r.summary_builder }, pagination: json_pagination(grants)})
  end

  def show

  end

  private
  def set_grant
    @grant = GshChildGrant.find(params[:id])
  end

  def set_batch
    @batch = GrantBatch.find(params[:grant_batch_id])
  end

end
