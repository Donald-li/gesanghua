class Admin::RemarksController < Admin::BaseController
  before_action :set_remark, only: [:edit, :update, :destroy]

  def index
    @search = Remark.sorted.ransack(params[:q])
    scope = @search.result.joins(:school)
    @remarks = scope.page(params[:page])
  end

  def new
    @remark = Remark.new(operator: current_user)
  end

  def edit
  end

  def create
    @remark = Remark.new(remark_params)
    @remark.operator = current_user

    respond_to do |format|
      if @remark.save
        format.html { redirect_to referer_or(request.referer), notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    byebug
    respond_to do |format|
      @remark.operator = current_user
      if @remark.update(remark_params)
        format.html { redirect_to referer_or(request.referer), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @remark.destroy
    respond_to do |format|
      format.html { redirect_to request.referer, notice: '删除成功。' }
    end
  end

  private

  # def set_owner
  #   @owner =
  # end

  # Use callbacks to share common setup or constraints between actions.
  def set_remark
    @remark = Remark.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def remark_params
    params.require(:remark).permit!
  end
end
