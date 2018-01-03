class Admin::CountyUsersController < Admin::BaseController

  before_action :set_county_user, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = CountyUser.sorted.ransack(params[:q])
    scope = @search.result
    @county_users = scope.page(params[:page])
  end

  def show
  end

  def new
    @county_user=CountyUser.new
  end

  def create
    @county_user = CountyUser.new(county_user_params)
    respond_to do |format|
      if @county_user.save
        format.html { redirect_to referer_or(admin_county_users_url), article: '用户已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @county_user.update(county_user_params)
        format.html { redirect_to referer_or(admin_county_users_url), county_user: '用户资料已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @county_user.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_county_users_url), county_user: '用户已删除。' }
    end
  end

  def switch
    User.find(@county_user.user_id).enabled? ? User.find(@county_user.user_id).disabled! : User.find(@county_user.user_id).enabled!
    redirect_to admin_county_users_url, notice:  User.find(@county_user.user_id).enabled? ? '用户已启用' : '用户已禁用'
  end

  private
  def set_county_user
    @county_user = CountyUser.find(params[:id])
  end

  def county_user_params
    params.require(:county_user).permit!
  end
end