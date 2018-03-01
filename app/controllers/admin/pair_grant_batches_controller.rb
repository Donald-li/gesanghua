class Admin::PairGrantBatchesController < Admin::BaseController

  def index
    @search = GrantBatch.search(params[:q])
    @batches = @search.result.sorted.page(params[:page])
  end

  def show
    @batch = GrantBatch.find(params[:id])
    @search = @batch.grants.search(params[:q])
    @items = @search.result.includes(:gsh_child, :school).all

    @grants = GshChildGrant.where('1<>1').search(params[:q]).result.page(1)
  end

  def new
    @batch = GrantBatch.new
  end

  def create
    @batch = GrantBatch.new(grant_params)
    if @batch.save
      redirect_to admin_pair_grant_batches_url, notice: '发放批次已创建。'
    else
      render :new
    end
  end

  def edit
    @batch = GrantBatch.find(params[:id])
  end

  def update
    @batch = GrantBatch.find(params[:id])

    respond_to do |format|
      if @batch.update(grant_params)
        format.html { redirect_to admin_pair_grant_batches_url, notice: '发放批次已更新。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @batch = GrantBatch.find(params[:id])

    @batch.destroy
    respond_to do |format|
      format.html { redirect_to admin_pair_grant_batches_url, notice: '发放批次已删除。' }
    end
  end

  private
    def grant_params
      params.require(:grant_batch).permit!
    end
end