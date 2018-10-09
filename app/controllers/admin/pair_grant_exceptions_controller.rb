class Admin::PairGrantExceptionsController < Admin::BaseController

  before_action :set_grant, only: [:new, :edit, :update]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = GshChildGrant.cancel.reverse_sorted.ransack(params[:q])
    scope = @search.result
    scope = scope.includes(:school, :gsh_child)
    @grants = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      if @grant.update(grant_params.merge(operator_id: current_user.id))
        format.html { redirect_to referer_or(admin_pair_grant_exceptions_url), notice: '修改成功。' }
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
