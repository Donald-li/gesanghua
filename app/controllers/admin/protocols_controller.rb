# 协议管理
class Admin::ProtocolsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_protocol, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = Protocol.sorted.ransack(params[:q])
    scope = @search.result
    @protocols = scope.page(params[:page])
  end

  def show
  end

  def new
    @protocol = Protocol.new
  end

  def edit
  end

  def create
    @protocol = Protocol.new(protocol_params)
    respond_to do |format|
      if @protocol.save
        format.html { redirect_to referer_or(admin_protocols_url), notice: '协议已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @protocol.update(protocol_params)
        format.html { redirect_to referer_or(admin_protocols_url), notice: '协议已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @protocol.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_protocols_url), notice: '协议已删除。' }
    end
  end

  def switch
    @protocol.show? ? @protocol.hidden! : @protocol.show!
    redirect_to admin_protocols_url, notice:  @protocol.show? ? '协议已展示' : '协议已隐藏'
  end

  private
    def set_protocol
      @protocol = Protocol.find(params[:id])
    end

    def protocol_params
      params.require(:protocol).permit!
    end
end
