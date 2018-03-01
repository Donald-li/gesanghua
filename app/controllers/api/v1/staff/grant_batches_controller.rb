class Api::V1::Staff::GrantBatchesController < Api::V1::BaseController

  before_action :set_batch, only: [:show]

  def index
    search = GrantBatch.search(params[:q])
    batches = search.result.sorted.page(params[:page])
    api_success(data: {grant_batches: batches.map { |r| r.summary_builder }, pagination: json_pagination(batches)})
  end

  def show
  end

  private
  def set_batch
    @batch = GrantBatch.find(params[:id])
  end

end
