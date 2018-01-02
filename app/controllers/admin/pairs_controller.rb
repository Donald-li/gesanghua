class Admin::PairsController < Admin::BaseController
  before_action :set_pair, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = Pair.sorted.ransack(params[:q])
    scope = @search.result
    @pairs = scope.page(params[:page])
  end

  def show
  end

  def new
    project_template = ProjectTemplate.find(1)
    @pair = project_template.pairs.new(contribute_kind: project_template.contribute_kind, fund_id: project_template.fund_id)
  end

  def edit
  end

  def create
    @pair = Pair.new(pair_params)

    respond_to do |format|
      if @pair.save
        format.html { redirect_to admin_pairs_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @pair.update(pair_params)
        format.html { redirect_to admin_pairs_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @pair.destroy
    respond_to do |format|
      format.html { redirect_to admin_pairs_path, notice: '删除成功。' }
    end
  end

  def switch
    @pair.enabled? ? @pair.disabled! : @pair.enabled!
    redirect_to admin_pairs_path, notice:  @pair.enabled? ? '已启用' : '已禁用'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pair
      @pair = Pair.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pair_params
      params.require(:pair).permit!
    end
end
