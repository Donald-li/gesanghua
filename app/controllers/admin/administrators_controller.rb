class Admin::AdministratorsController < Admin::BaseController
  before_action :set_administrator, only: [:show, :edit, :update, :destroy, :switch]
  before_action :protect_check, only: [:destroy, :switch]

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = User.admin_user.ransack(params[:q])
    scope = @search.result
    @administrators = scope.sorted.page(params[:page])
  end

  def show
  end

  def new
    @administrator = User.new
  end

  def edit
  end

  def create
    respond_to do |format|
      @administrator = User.find_by(phone: administrator_params[:phone])
      if @administrator.present?
        roles = @administrator.roles
        administrator_params[:roles] = (administrator_params[:roles] | (roles & User::USER_ROLES)).select(&:present?)
        if @administrator.update(administrator_params)
          format.html {redirect_to referer_or(admin_administrators_url), notice: '该手机号已绑定用户，已将该用户账号更新为管理员账号。'}
        else
          format.html {render :new}
        end
      else
        @administrator = User.new

        if User.find_by_login(administrator_params[:login]).present?
          flash[:alert] = '账号已被占用'
          format.html {render :new}
        else
          administrator_params[:roles] = (administrator_params[:roles]).select(&:present?)
          @user = User.new(administrator_params.merge(name: administrator_params[:nickname]))
          if @user.save
            format.html {redirect_to referer_or(admin_administrators_url), notice: '管理员已增加。'}
          else
            flash[:alert] = @user.errors.full_messages.join(',')
            format.html {render :new}
          end
        end
      end
    end

  end

  def update
    roles = @administrator.roles
    administrator_params[:roles] = (administrator_params[:roles] | (roles & User::USER_ROLES)).select(&:present?)
    respond_to do |format|
      if @administrator.update(administrator_params)
        format.html {redirect_to referer_or(admin_administrators_url), notice: '管理员资料已修改。'}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @administrator.update(roles: @administrator.roles & User::USER_ROLES)
    respond_to do |format|
      format.html {redirect_to referer_or(admin_administrators_url), notice: '管理员已删除。'}
    end
  end

  def switch
    @administrator.enable? ? @administrator.disable! : @administrator.enable!
    redirect_to referer_or(admin_administrators_url), notice: @administrator.enable? ? '管理员已启用' : '管理员已禁用'
  end

  private
  def set_administrator
    @administrator = User.admin_user.find(params[:id])
  end

  def administrator_params
    ps = params.require(:user).permit!
    ps[:project_ids] = ps[:project_ids].select {|i| i.present?}.map(&:to_i)
    ps
  end

  def protect_check
    if @administrator.id === current_user.id || @administrator.kind === 'super_administrator'
      respond_to do |format|
        format.html {redirect_to referer_or(admin_administrators_url), alert: "不可对该管理员执行此操作。"}
      end
      return
    end
  end
end
