class Admin::CampaignCategoriesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_campaign_category, only: [:show, :edit, :update, :destroy, :cancel]

  def index
    @search = CampaignCategory.all.sorted.ransack(params[:q])
    scope = @search.result
    @campaign_categories = scope.page(params[:page])
  end

  def new
    @campaign_category = CampaignCategory.new
  end

  def edit
  end

  def create
    @campaign_category = CampaignCategory.new(campaign_category_params)
    respond_to do |format|
      if @campaign_category.save
        format.html { redirect_to admin_campaign_categories_path, notice: '活动分类创建成功。' }
      else
        format.html { render :new  }
      end
    end
  end

  def update
    respond_to do |format|
      if @campaign_category.update(campaign_category_params)
        format.html { redirect_to admin_campaign_categories_path, notice: '活动分类已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @campaign_category.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_campaign_categories_url), notice: '活动分类已删除。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign_category
      @campaign_category = CampaignCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_category_params
      params.require(:campaign_category).permit!
    end
end
