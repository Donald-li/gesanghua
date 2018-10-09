class Admin::SpecialAdvertsController < Admin::BaseController

  before_action :set_special_advert, only: [:edit, :update, :destroy]
  before_action :set_special

  def new
    @advert = Advert.new
    set_item_kind(params[:item_kind])
  end

  def edit
  end

  def create
    @advert = Advert.new(special_advert_params.merge(kind: 2))
    respond_to do |format|
      if @advert.save
        @advert.attach_image(params[:image_id])
        @special.special_adverts.create(advert_id: @advert.id, kind: session[:item_kind])
        format.html { redirect_to referer_or(edit_admin_special_path(@special, anchor: "#{session[:item_kind]}-adverts")), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @advert.update(special_advert_params)
        @advert.attach_image(params[:image_id])
        format.html { redirect_to referer_or(edit_admin_special_path(@special, anchor: "#{session[:item_kind]}-adverts")), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @advert.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(edit_admin_special_path(@special, anchor: "#{session[:item_kind]}-adverts")), notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_advert
      @advert = Advert.find(params[:id])
    end

    def set_item_kind(kind)
      session[:item_kind] = kind
    end

    def set_special
      @special = Special.find(params[:special_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def special_advert_params
      params.require(:advert).permit!
    end
end
