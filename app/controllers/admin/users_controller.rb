class Admin::UsersController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_user, only: [:edit, :update, :switch, :invoices, :bill]

  def index
    respond_to do |format|
      format.html do # HTML页面
        set_search_end_of_day(:created_at_lteq)
        @search = User.ransack(params[:q])
        scope = @search.result
        @users = scope.sorted.page(params[:page])
      end
      #format.json do # Select2 异步选择用户搜索
      #  users = User.enable.where.not(users: {id: 1}).left_joins(:gsh_child).where(gsh_children: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
      #  render json: {items: users.as_json(only: [:id, :name])}
      #end
    end

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.attach_avatar(params[:avatar_id])
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    roles = @user.roles
    user_params[:roles] = (user_params[:roles] | ( roles & [:superadmin, :admin])).select(&:present?)
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
    redirect_to admin_users_url, notice:  @user.enable? ? '用户账号已启用' : '用户账号已禁用'
  end

  def invoices
    @records = @user.donate_records.to_bill
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
      if @voucher.save_voucher(ids)
        format.html { redirect_to invoices_admin_user_path(@user), notice: '开票申请提交成功。' }
      else
        format.html { redirect_to invoices_admin_user_path(@user), alert: '开票申请提交失败。' }
      end
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
