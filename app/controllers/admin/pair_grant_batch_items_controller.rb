class Admin::PairGrantBatchItemsController < Admin::BaseController
  before_action :check_auth
  before_action :find_batch

  def index
    @search = GshChildGrant.waiting.succeed.where(grant_batch_id: nil).includes(:gsh_child).order("title asc").order("gsh_children.gsh_no asc").search(params[:q])
    @grants = @search.result.sorted.page(params[:page])
  end

  def create
    @grant = GshChildGrant.waiting.succeed.find(params[:grant_id])
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

  def check_auth
    auth_operate_project(Project.pair_project)
  end

end
