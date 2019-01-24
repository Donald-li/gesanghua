class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :switch, :invoices, :bill, :combine, :set_combine, :manager, :set_manager]

  def index
    respond_to do |format|
      set_search_end_of_day(:created_at_lteq)
      @search = User.ransack(params[:q])
      scope = @search.result
      scope = scope.where(id: params[:user_id]) if params[:user_id].present?
      format.html do # HTML页面
        @users = scope.includes(:volunteer).sorted.page(params[:page])
      end
      format.xlsx {
        @users = scope.sorted
        OperateLog.create_export_excel(current_user,  '用户名单')
        response.headers['Content-Disposition'] = 'attachment; filename="用户名单"' + Date.today.to_s + '.xlsx'
      }
      #format.json do # Select2 异步选择用户搜索
      #  users = User.enable.where.not(users: {id: 1}).left_joins(:gsh_child).where(gsh_children: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
      #  render json: {items: users.as_json(only: [:id, :name])}
      #end
    end

  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    user_params[:roles] = (user_params[:roles]).select(&:present?) if user_params[:roles].present?
    @user = User.new(user_params)
    @user.attach_avatar(params[:avatar_id])
    respond_to do |format|
      if @user.save
        format.html { redirect_to referer_or(admin_users_path), notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    roles = @user.roles
    user_params[:roles] = (user_params[:roles] | ( roles & User::SUPERADMIN_ROLES)).select(&:present?) if user_params[:roles].present?
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
    @user.enable? ? @user.disable! : @user.enable!
    redirect_to referer_or(admin_users_url), notice:  @user.enable? ? '用户账号已启用' : '用户账号已禁用'
  end

  def invoices
    @records = @user.income_records.to_bill
    set_search_end_of_day(:created_at_lteq)
    @search = @records.ransack(params[:q])
    scope = @search.result
    @records = scope.sorted.page(params[:page])
    @voucher =  @user.vouchers.build
  end

  def bill
    @voucher = @user.vouchers.build(voucher_params)
    ids = Array(params[:ids])
    respond_to do |format|
      if @voucher.save_voucher(@user, ids)
        format.html { redirect_to referer_or(invoices_admin_user_path(@user)), notice: '开票申请提交成功。' }
      else
        format.html { redirect_to referer_or(invoices_admin_user_path(@user)), alert: '开票申请提交失败。' }
      end
    end

  end

  def combine
  end

  def set_combine
    @new_user = User.find_by(id: user_params[:new_user_id])
    if User.admin_combine_user(@user, @new_user, current_user)
      redirect_to referer_or(admin_user_path(@user)), notice: '操作成功。'
    else
      redirect_to referer_or(admin_user_path(@user)), alert: '操作失败。'
    end
  end

  def manager
  end

  def set_manager
    old_manager = User.find_by(id: @user.manager_id)
    manager = User.find_by(id: user_params[:manager_id])
    result, message = @user.set_offline_user_manager(manager, old_manager, current_user)
    if result && @user.update(manager: manager)
      redirect_to admin_user_path(@user), notice: '操作成功。'
    else
      redirect_to admin_user_path(@user), alert: message
    end
  end

  def batch_manage
  end

  def send_message
    if params[:send_way] == 'total'
      user_ids = User.where.not(profile: {}).pluck(:id)
    elsif params[:send_way] == 'filter'
      user_ids = params[:user_ids_array].split(',')
    else
      user_ids = params[:user_ids]
    end
    if User.send_messages(user_ids, params[:content])
      redirect_to batch_manage_admin_users_path, notice: "发送成功 #{user_ids.count} 条"
    else
      redirect_to batch_manage_admin_users_path, notice: '发送失败。'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit!
    end

    def voucher_params
      params.require(:voucher).permit!
    end
end
