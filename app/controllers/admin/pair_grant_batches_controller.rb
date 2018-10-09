class Admin::PairGrantBatchesController < Admin::BaseController

  def index
    @search = GrantBatch.search(params[:q])
    @batches = @search.result.sorted.page(params[:page])
  end

  # def excel_output
  #   @batch = GrantBatch.find(params[:format])
  #   path = ExcelOutput.grant_batch_output(@batch)
  #   send_file(path, filename: "结对助学发放批次名单.xlsx")
  # end

  def show
    @batch = GrantBatch.find(params[:id])
    @search = @batch.grants.search(params[:q])

    @grants = GshChildGrant.where('1<>1').search(params[:q]).result.includes(:gsh_child).order("gsh_children.gsh_no asc").page(1) # .order("title asc")
    @items = @search.result.includes(:gsh_child, :school).order("gsh_children.gsh_no asc")
    respond_to do |format|
      format.html {}
      format.js {}
      format.xlsx {
        OperateLog.create_export_excel(current_user, '结对助学发放批次名单')
        response.headers['Content-Disposition'] = 'attachment; filename= "结对助学发放批次名单" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def new
    @batch = GrantBatch.new
  end

  def create
    @batch = GrantBatch.new(grant_params)
    if @batch.save
      if @batch.grant_at.present?
        @batch.grants.update(granted_at: @batch.grant_at)
      end
      redirect_to referer_or(admin_pair_grant_batches_url), notice: '发放批次已创建。'
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
        if @batch.grant_at.present?
          @batch.grants.update(granted_at: @batch.grant_at)
        end

        format.html { redirect_to referer_or(admin_pair_grant_batches_url), notice: '发放批次已更新。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @batch = GrantBatch.find(params[:id])

    @batch.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_pair_grant_batches_url), notice: '发放批次已删除。' }
    end
  end

  private
  def grant_params
    params.require(:grant_batch).permit!
  end

end
