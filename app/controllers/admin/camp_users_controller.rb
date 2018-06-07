class Admin::CampUsersController < Admin::BaseController
  before_action :check_auth
  before_action :set_camp_user, only: [:edit, :update, :destroy]
  before_action :set_camp

  def index
    @search = @camp.users.sorted.ransack(params[:q])
    scope = @search.result
    @camp_users = scope.page(params[:page])
  end

  def new
    @camp_user = User.new
  end

  def edit
  end

  def create
    @camp_user = User.new(camp_user_params.merge(camp: @camp))
    @camp_user.add_role(:camp_manager)
    respond_to do |format|
      if @camp_user.save
        @camp_user.attach_avatar(params[:avatar_id])
        format.html { redirect_to referer_or(admin_camp_camp_users_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @camp_user.update(camp_user_params)
        @camp_user.attach_avatar(params[:avatar_id])
        format.html { redirect_to referer_or(admin_camp_camp_users_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @camp_user.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_camp_camp_users_path), notice: '删除成功。' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_camp_user
    @camp_user = User.find(params[:id])
  end

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def camp_user_params
    params.require(:user).permit!
  end

  def check_auth
    auth_operate_project(Project.camp_project)
  end

end
