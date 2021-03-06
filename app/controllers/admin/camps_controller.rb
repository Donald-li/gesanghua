class Admin::CampsController < Admin::BaseController
  before_action :set_camp, only: [:edit, :update, :destroy]

  def index
    @search = Camp.sorted.ransack(params[:q])
    scope = @search.result.includes(:fund)
    @camps = scope.page(params[:page])
  end

  def new
    @camp = Camp.new
  end

  def edit
  end

  def create
    @camp = Camp.new(camp_params)
    respond_to do |format|
      if @camp.save
        format.html { redirect_to referer_or(admin_camps_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @camp.update(camp_params)
        format.html { redirect_to referer_or(admin_camps_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      @camp.users.each do |user|
        user.remove_role(:camp_manager)
        user.save
      end
      if @camp.destroy
        format.html { redirect_to referer_or(admin_camps_path), notice: '删除成功。' }
      else
        format.html { redirect_to referer_or(admin_camps_path), notice: '请先删除该营下的项目记录。' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp
      @camp = Camp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def camp_params
      params.require(:camp).permit!
    end

end
