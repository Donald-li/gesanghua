class Admin::PairGrantsController < Admin::BaseController
  before_action :set_grant, only: [:edit, :update, :destroy, :switch]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = GshChildGrant.sorted.ransack(params[:q])
    scope = @search.result
    @grants = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      if @grant.update(grant_params)
        format.html { redirect_to referer_or(admin_pair_grants_url), grant: '项目报告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @grant.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_pair_grants_url), grant: '项目报告已删除。' }
    end
  end

  def switch
    @grant.show? ? @grant.hidden! : @grant.show!
    redirect_to admin_pair_grants_url, notice:  @grant.show? ? '项目报告已展示' : '项目报告已隐藏'
  end

  private
    def set_grant
      @grant = GshChildGrant.find(params[:id])
    end

    def grant_params
      params.require(:gsh_child_grant).permit!
    end
end
