class Admin::PairGrantsController < Admin::BaseController
  before_action :set_grant, only: [:edit, :update, :destroy, :switch, :edit_delay, :edit_cancel]

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
      @grant.attach_images(params[:image_ids])
      if @grant.update(grant_params)
        @grant.granted!
        format.html { redirect_to referer_or(admin_pair_grants_url), grant: '项目报告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def edit_delay
  end

  def edit_cancel
  end

  def update_delay
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.suspend!
        format.html { redirect_to referer_or(admin_pair_grants_url), grant: '项目报告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def update_cancel
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.cancel!
        format.html { redirect_to referer_or(admin_pair_grants_url), grant: '项目报告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  # def destroy
  #   @grant.destroy
  #   respond_to do |format|
  #     format.html { redirect_to referer_or(admin_pair_grants_url), grant: '项目报告已删除。' }
  #   end
  # end


  private
    def set_grant
      @grant = GshChildGrant.find(params[:id])
    end

    def grant_params
      params.require(:gsh_child_grant).permit!
    end
end
