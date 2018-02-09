class Admin::DonationManagesController < Admin::BaseController
  before_action :set_donation, only: [:show, :edit, :update, :destroy, :switch, :move]

  def index
    @search = Donation.sorted.ransack(params[:q])
    scope = @search.result
    @donations = scope.page(params[:page])
  end

  def show
  end

  def new
    @donation = Donation.new
  end

  def edit
  end

  def create
    @donation = Donation.new(donation_params)
    respond_to do |format|
      if @donation.save
        @donation.attach_logo(params[:logo_id])
        format.html { redirect_to admin_donation_manages_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @donation.update(donation_params)
        @donation.attach_logo(params[:logo_id])
        format.html { redirect_to admin_donation_manages_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @donation.destroy
    respond_to do |format|
      format.html { redirect_to admin_donation_manages_path, notice: '删除成功。' }
    end
  end

  def switch
    @donation.show? ? @donation.hidden! : @donation.show!
    redirect_to admin_donation_manages_url, notice:  @donation.show? ? '捐助已展示' : '捐助已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @donation.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_params
      params.require(:donation).permit!
    end
end
