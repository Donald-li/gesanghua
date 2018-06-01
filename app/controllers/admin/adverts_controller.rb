class Admin::AdvertsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_advert, only: [:show, :edit, :update, :destroy, :switch, :move]

  def index
    @search = Advert.where(kind: [1, 3, 4]).sorted.ransack(params[:q])
    scope = @search.result
    @adverts = scope.includes(:image).sorted.page(params[:page])
  end

  def show
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @advert.send("move_#{move_target}")
    redirect_to request.referer
  end

  def new
    @advert = Advert.new
  end

  def edit
  end

  def create
    @advert = Advert.new(advert_params)
    respond_to do |format|
      if @advert.save
        @advert.update_columns(user_id: current_user.try(:id))
        @advert.attach_image(params[:image_id])
        format.html { redirect_to referer_or(admin_adverts_url), notice: '广告已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @advert.update(advert_params)
        @advert.update_columns(user_id: current_user.try(:id))
        @advert.attach_image(params[:image_id])
        format.html { redirect_to referer_or(admin_adverts_url), notice: '广告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @advert.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_adverts_url), notice: '广告已删除。' }
    end
  end

  def switch
    @advert.show? ? @advert.hidden! : @advert.show!
    redirect_to admin_adverts_url, notice:  @advert.show? ? '广告已显示' : '广告已隐藏'
  end

  private
    def set_advert
      @advert = Advert.find(params[:id])
    end

    def advert_params
      params.require(:advert).permit!
    end
end
