class Camp::SessionsController < Camp::BaseController
  skip_before_action :login_require, only: [:new, :create]
  layout 'blank'

  def new
    @camp = User.new
  end

  def create
    @camp = User.new(session_params.permit!)
    if !verify_rucaptcha?
      flash[:alert] = '验证码错误'
      render action: :new and return
    end
    camp =  User.find_by(login: session_params[:login])
    unless camp && camp.has_role?(:camp_manager)
      flash[:alert] = '该帐号不存在'
      render(action: :new) && return
    end
    @camp = camp
    if camp.state === 'disable'
      flash[:alert] = '该帐号已被停用'
      render(action: :new) && return
    end
    if camp.authenticate(session_params[:password])
      set_current_user(camp)
      redirect_to camp_main_path
    else
      flash[:alert] = '用户密码错误'
      render(action: :new) && return
    end
  end

  def destroy
    reset_session
    redirect_to camp_login_path
  end

  private

  def session_params
    params.require(:user).permit(:login, :password)
  end

  def set_current_user(camp)
    session[:camp_user_id] = camp.id
  end
end
