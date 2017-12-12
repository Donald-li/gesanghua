class Admin::SupportsController < Admin::BaseController
  before_action :set_support, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = Support.sorted.ransack(params[:q])
    scope = @search.result
    @supports = scope.page(params[:page])
  end

  def show
  end

  def new
    @support = Support.new
  end

  def edit
  end

  def create
    @support = Support.new(support_params)
    respond_to do |format|
      if @support.save
        @support.attach_image(params[:image_id])
        format.html { redirect_to admin_supports_url, notice: '新增成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @support.update(support_params)
        format.html { redirect_to admin_supports_url, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @support.send("move_#{move_target}")
    redirect_to request.referer
  end

  def switch
    @support.show? ? @support.hidden! : @support.show!
    redirect_to admin_supports_url, notice:  @support.show? ? '帮助已显示' : '帮助已隐藏'
  end

  def destroy
    @support.destroy
    respond_to do |format|
      format.html { redirect_to admin_supports_url, notice: '删除成功' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_support
      @support = Support.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def support_params
      params.require(:support).permit!
    end
end
