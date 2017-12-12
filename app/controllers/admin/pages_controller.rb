class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = Page.sorted.ransack(params[:q])
    scope = @search.result
    @pages = scope.page(params[:page])
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    respond_to do |format|
      if @page.save
        format.html { redirect_to admin_pages_url, notice: '新增成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to admin_pages_url, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @page.send("move_#{move_target}")
    redirect_to request.referer
  end

  def switch
    @page.show? ? @page.hidden! : @page.show!
    redirect_to admin_pages_url, notice:  @page.show? ? '帮助已显示' : '帮助已隐藏'
  end

  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to admin_pages_url, notice: '删除成功' }
    end
  end

  private
    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit!
    end
end
