class Admin::FundsController < Admin::BaseController

  before_action :set_fund, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = Fund.sorted.ransack(params[:q])
    scope = @search.result
    @funds = scope.page(params[:page])
  end

  def new
    @fund = Fund.new
  end

  def edit
  end

  def create
    @fund = Fund.new(fund_params)

    respond_to do |format|
      if @fund.save
        format.html { redirect_to referer_or(admin_fund_categories_path), notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @fund.update(fund_params)
        format.html { redirect_to referer_or(admin_fund_categories_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @fund.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_fund_categories_path), notice: '删除成功。' }
    end
  end

  def switch
    @fund.show? ? @fund.hidden! : @fund.show!
    redirect_to referer_or(admin_fund_categories_path), notice:  @fund.show? ? '已显示' : '已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @fund.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    def set_fund
      @fund = Fund.find(params[:id])
    end

    def fund_params
      params.require(:fund).permit!
    end
end
