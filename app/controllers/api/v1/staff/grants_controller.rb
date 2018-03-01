class Api::V1::Staff::GrantsController < Api::V1::BaseController

  before_action :set_batch
  before_action :set_grant, only: [:show, :update]

  def index
    search = @batch.grants.search(params[:q])
    grants = search.result.sorted.page(params[:page])
    api_success(data: {grants: grants.map { |r| r.summary_builder }, pagination: json_pagination(grants)})
  end

  def update
    @grant.update(grant_params)
    api_success(message: '发放成功')
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

  def grant_params
    params.permit(:grant_person, :grant_remark, :granted_at)
  end

end
