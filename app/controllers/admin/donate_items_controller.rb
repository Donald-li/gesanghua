class Admin::DonateItemsController < Admin::BaseController

  before_action :set_donate_item, only: [:show, :edit, :update, :destroy, :switch, :move]

  def index
    @search = DonateItem.sorted.ransack(params[:q])
    scope = @search.result.includes(fund:[:fund_category])
    @donate_items = scope.page(params[:page])
  end

  def show
  end

  def new
    @donate_item = DonateItem.new
  end

  def edit
  end

  def create
    @donate_item = DonateItem.new(donate_item_params)
    respond_to do |format|
      if @donate_item.save
        format.html { redirect_to referer_or(admin_donate_items_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @donate_item.update(donate_item_params)
        format.html { redirect_to referer_or(admin_donate_items_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @donate_item.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_donate_items_path), notice: '删除成功。' }
    end
  end

  def switch
    @donate_item.show? ? @donate_item.hidden! : @donate_item.show!
    redirect_to referer_or(admin_donate_items_url), notice:  @donate_item.show? ? '捐助已展示' : '捐助已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @donate_item.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donate_item
      @donate_item = DonateItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donate_item_params
      params.require(:donate_item).permit!
    end
end
