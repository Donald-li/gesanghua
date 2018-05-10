class Admin::SessionsController < Admin::BaseController
  skip_before_action :login_require, only: [:new, :create]
  layout 'blank'

  def new
    @admin = User.new
  end

  def create
    @admin = User.new(session_params.permit!)
    if !verify_rucaptcha?
      flash[:alert] = '验证码错误'
      render action: :new and return
    end
    admin =  User.find_by(login: session_params[:login])
    unless admin && admin.has_role?([:superadmin, :admin, :project_manager, :project_operator, :financial_staff])
      flash[:alert] = '该帐号不存在'
      render(action: :new) && return
    end
    @admin = admin
    if admin.state === 'disable'
      flash[:alert] = '该帐号已被停用'
      render(action: :new) && return
    end
    if admin.authenticate(session_params[:password])
      set_current_user(admin)
      redirect_to admin_main_path
    else
      flash[:alert] = '用户密码错误'
      render(action: :new) && return
    end
  end

  def destroy
    reset_session
    redirect_to admin_login_path
  end

  private

  def session_params
    params.require(:administrator).permit(:login, :password)
  end

  def set_current_user(admin)
    session[:admin_user_id] = admin.id
    Rails.cache.write("donate_project_#{admin.id}", Project.donate_project)

    # 因为后台现在只有一个登录入口，所以在这个方法里记登录日志
    # log = admin.administrator_logs.new(kind: 1, ip: request.remote_ip)
    # log.save
  end
end
