class Admin::PartnersController < Admin::BaseController
  before_action :set_partner, only: [:edit, :update, :destroy, :switch, :move]

  def index
    @search = Partner.sorted.ransack(params[:q])
    scope = @search.result
    @partners = scope.page(params[:page])
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @partner.send("move_#{move_target}")
    redirect_to request.referer
  end

  def new
    @partner = Partner.new
  end

  def edit
  end

  def create
    @partner = Partner.new(partner_params)
    respond_to do |format|
      if @partner.save
        @partner.attach_image(params[:image_id])
        format.html { redirect_to referer_or(admin_partners_url), notice: '合作伙伴已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @partner.update(partner_params)
        @partner.attach_image(params[:image_id])
        format.html { redirect_to referer_or(admin_partners_url), notice: '合作伙伴已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @partner.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_partners_url), notice: '合作伙伴已删除。' }
    end
  end

  def switch
    @partner.show? ? @partner.hidden! : @partner.show!
    redirect_to admin_partners_url, notice:  @partner.show? ? '合作伙伴已显示' : '合作伙伴已隐藏'
  end

  private
    def set_partner
      @partner = Partner.find(params[:id])
    end

    def partner_params
      params.require(:partner).permit!
    end
end
