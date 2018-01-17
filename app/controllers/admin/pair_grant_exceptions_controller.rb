class Admin::PairGrantExceptionsController < Admin::BaseController
  before_action :set_grant, only: [:new, :edit, :update]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = GshChildGrant.succeed.cancel.sorted.ransack(params[:q])
    scope = @search.result
    scope = scope.includes(:school, :gsh_child)
    @grants = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      @grant.attach_images(params[:image_ids])
      if @grant.update(grant_params)
        @grant.granted!
        format.html { redirect_to admin_pair_grants_path, notice: '操作成功。' }
      else
        format.html { render :edit }
      end
    end
  end


  private
    def set_grant
      @grant = GshChildGrant.find(params[:id])
    end

    def grant_params
      params.require(:gsh_child_grant).permit!
    end
end
