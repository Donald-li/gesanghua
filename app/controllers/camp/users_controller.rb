class Camp::UsersController < Camp::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_camp

  def index
    @search = @camp.users.sorted.ransack(params[:q])
    scope = @search.result
    @users = scope.page(params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params.merge(camp: @camp))
    @user.add_role(:camp_manager)
    respond_to do |format|
      if @user.save
        @user.attach_avatar(params[:avatar_id])
        format.html { redirect_to camp_users_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        @user.attach_avatar(params[:avatar_id])
        format.html { redirect_to camp_users_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to camp_users_path, notice: '删除成功。' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_camp
    @camp = current_user.camp
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit!
  end
end
