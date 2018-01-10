class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :switch]

  def index
    respond_to do |format|
      format.html do # HTML页面
        set_search_end_of_day(:created_at_lteq)
        @search = User.ransack(params[:q])
        scope = @search.result
        @users = scope.sorted.page(params[:page])
      end
      #format.json do # Select2 异步选择用户搜索
      #  users = User.enabled.where.not(users: {id: 1}).left_joins(:gsh_child).where(gsh_children: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
      #  render json: {items: users.as_json(only: [:id, :name])}
      #end
    end

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        @user.attach_avatar(params[:avatar_id])
        format.html { redirect_to admin_users_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
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
