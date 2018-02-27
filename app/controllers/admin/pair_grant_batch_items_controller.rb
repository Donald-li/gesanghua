class Admin::PairGrantBatchItemsController < Admin::BaseController
  before_action :find_batch

  def index
    @search = Grant.waiting.where(grant_batch_id: nil).search(params[:q])
    @grants = @search.result.sorted.page(params[:page])
  end

  def create
    @grant = Grant.waiting.find(params[:grant_id])
    @exist = (@grant.grant_batch == @batch)
    @grant.grant_batch = @batch
    @result = @grant.save
    @grants = @batch.grants.page(1)
  end

  def destroy
    @grant = @batch.grants.find(params[:id])
    @result = @grant.update(grant_batch_id: nil)
    @grants = @batch.grants.page(1)
  end

  private
  def find_batch
    @batch = GrantBatch.find(params[:pair_grant_batch_id])
  end
end
