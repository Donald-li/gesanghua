class Admin::DonateItemAmountTabsController < Admin::BaseController
  before_action :set_donate_item, only: [:new, :index, :create, :edit, :update, :destroy, :switch]
  before_action :set_amount_tab, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = @donate_item.amount_tabs.sorted.ransack(params[:q])
    scope = @search.result
    @amount_tabs = scope.page(params[:page])
  end

  def show
  end

  def new
    @amount_tab = @donate_item.amount_tabs.new
  end

  def edit
  end

  def create
    @amount_tab = @donate_item.amount_tabs.new(amount_tab_params)
    respond_to do |format|
      if @amount_tab.save
        format.html { redirect_to referer_or(admin_donate_item_donate_item_amount_tabs_url(@donate_item)), notice: '金额选项卡已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @amount_tab.update(amount_tab_params)
        format.html { redirect_to referer_or(admin_donate_item_donate_item_amount_tabs_url(@donate_item)), notice: '金额选项卡已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @amount_tab.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_donate_item_donate_item_amount_tabs_url(@donate_item)), notice: '金额选项卡已删除。' }
    end
  end

  def switch
    @amount_tab.show? ? @amount_tab.hidden! : @amount_tab.show!
    redirect_to admin_donate_item_donate_item_amount_tabs_url(@donate_item), notice:  @amount_tab.show? ? '金额选项卡已显示' : '金额选项卡已隐藏'
  end

  private

    def set_donate_item
      @donate_item = DonateItem.find(params[:donate_item_id])
    end

    def set_amount_tab
      @amount_tab = AmountTab.find(params[:id])
    end

    def amount_tab_params
      params.require(:amount_tab).permit!
    end
end
