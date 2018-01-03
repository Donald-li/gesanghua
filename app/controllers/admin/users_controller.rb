class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :switch, :move]

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = User.ransack(params[:q])
    scope = @search.result
    @users = scope.sorted.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        @user.attach_avatar(params[:avatar_id])
        format.html { redirect_to referer_or(admin_users_url), notice: '用户已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def switch
    @user.enabled? ? @user.disabled! : @user.enabled!
    redirect_to admin_users_url, notice:  @user.enabled? ? '用户账号已启用' : '用户账号已停用'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit!
    end
end
