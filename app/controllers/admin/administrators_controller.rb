class Admin::AdministratorsController < Admin::BaseController
  before_action :check_super_administrator
  before_action :set_administrator, only: [:show, :edit, :update, :destroy, :switch]
  before_action :protect_check, only: [:destroy, :switch]

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = Administrator.ransack(params[:q])
    scope = @search.result
    @administrators = scope.sorted.page(params[:page])
  end

  def show
  end

  def new
    @administrator = Administrator.new
  end

  def edit
  end

  def create
    @administrator = Administrator.new
    respond_to do |format|
      if User.find_by(login: administrator_params[:user][:login]).present?
        flash[:alert] = '账号已被占用'
        format.html {render :new}
      else
        @user = User.new(administrator_params[:user].merge(name: administrator_params[:nickname]))
        if @user.save && Administrator.create(administrator_params.except(:user).merge(user_id: @user.id))
          format.html {redirect_to referer_or(admin_administrators_url), notice: '管理员已增加。'}
        else
          format.html {render :new}
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @administrator.update(administrator_params)
        format.html {redirect_to referer_or(admin_administrators_url), notice: '管理员资料已修改。'}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @administrator.destroy
    respond_to do |format|
      format.html {redirect_to referer_or(admin_administrators_url), notice: '管理员已删除。'}
    end
  end

  def switch
    @administrator.enable? ? @administrator.disable! : @administrator.enable!
    redirect_to admin_administrators_url, notice: @administrator.enable? ? '管理员已启用' : '管理员已禁用'
  end

  private
  def set_administrator
    @administrator = Administrator.find(params[:id])
  end

  def administrator_params
    params.require(:administrator).permit!
  end

  def check_super_administrator
    if current_administrator.kind != 'super_administrator'
      respond_to do |format|
        format.html {redirect_to referer_or(admin_main_url), alert: "您不是超级管理员。"}
      end
      return
    end
  end

  def protect_check
    if @administrator.id === current_administrator.id || @administrator.kind === 'super_administrator'
      respond_to do |format|
        format.html {redirect_to referer_or(admin_administrators_url), alert: "不可对该管理员执行此操作。"}
      end
      return
    end
  end
end
