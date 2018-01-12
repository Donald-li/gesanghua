class Admin::PairGrantsController < Admin::BaseController
  before_action :set_grant, only: [:edit, :update, :destroy, :switch]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = ProjectReport.where(project_id: 1).sorted.ransack(params[:q])
    scope = @search.result
    @grants = scope.page(params[:page])
  end

  def new
    @grant = ProjectReport.new
  end

  def edit
  end

  def create
    @grant = ProjectReport.new(grant_params.merge(project_id: 1, user_id: current_user.id))
    @grant.attach_images(params[:image_ids])
    respond_to do |format|
      if @grant.save
        format.html { redirect_to referer_or(admin_pair_grants_url), grant: '项目报告已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @grant.attach_images(params[:image_ids])
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
      @grant = ProjectReport.find(params[:id])
    end

    def grant_params
      params.require(:project_grant).permit!
    end
end
