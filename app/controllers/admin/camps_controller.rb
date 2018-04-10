class Admin::CampsController < Admin::BaseController
  before_action :check_auth
  before_action :set_camp, only: [:edit, :update, :destroy]

  def index
    @search = Camp.sorted.ransack(params[:q])
    scope = @search.result
    @camps = scope.page(params[:page])
  end

  def new
    @camp = Camp.new
  end

  def edit
  end

  def create
    @camp = Camp.new(camp_params)
    user = User.find(camp_params[:manager_id])
    respond_to do |format|
      if @camp.save
        user.camp_id = @camp.id
        user.add_role(:camp_manager)
        user.save
        format.html { redirect_to admin_camps_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    user = User.find(camp_params[:manager_id])
    respond_to do |format|
      if @camp.update(camp_params)
        user.update(camp_id: @camp.id)
        format.html { redirect_to admin_camps_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @camp.destroy
    respond_to do |format|
      format.html { redirect_to admin_camps_path, notice: '删除成功。' }
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

    def check_auth
      auth_operate_project(Project.camp_project)
    end
end
