class Account::SessionsController < Account::BaseController
  skip_before_action :logged_in?

  layout 'application'

  def new
    @user = User.new
  end

  def create
    @user = User.new session_params.permit!
    if !verify_rucaptcha?
      flash[:alert] = '验证码错误'
      render action: :new and return
    end
    user = User.find_by(login: session_params[:login])
    if user.blank?
      flash[:alert] = '该帐号不存在'
      render(action: :new) && return
    end
    if user.state === 'disable'
      flash[:alert] = '该帐号已被停用'
      render(action: :new) && return
    end
    if user.authenticate(session_params[:password])
      set_current_user(user)
      redirect_to user_schools_path
    else
      flash[:alert] = '用户密码错误'
      render(action: :new) && return
    end
  end


  def forget
    @user = User.new
  end

  def find_back
    respond_to do |format|
      if session_params[:login].blank?
        format.html {redirect_to forget_user_session_url, alert: '请输入手机号'}
      else
        if params[:code].empty?
          render js: "alert('验证码不能为空');" and return
        end

        unless SmsCode.valid_code?(mobile: session_params[:login], code: params[:code].to_i)
          render js: "alert('验证码不正确');closeCaptchaModal();refreshCaptcha();" and return
        end

        @user = User.find_by(login: session_params[:login])
        if @user.blank?
          flash[:alert] = '该帐号不存在'
          render(action: :new) && return
        end
        if @user.state === 'disable'
          flash[:alert] = '该帐号已被停用'
          render(action: :new) && return
        end
        set_reset_user(@user)
        format.html {redirect_to edit_user_session_url}
      end
    end
  end

  def info
  end

  def edit
    @user = User.find(session[:reset_user_id])
  end

  def update
    respond_to do |format|
      unless session_params[:password] === session_params[:password_confirmation]
        format.html { redirect_to edit_user_session_url, alert: '确认密码不正确。' }
      else
        if User.find(session[:reset_user_id]).update(password: session_params[:password])
          reset_session
          format.html { redirect_to info_user_session_path, notice: '密码已重置。' }
        else
          format.html { redirect_to edit_user_session_url }
        end
      end
    end
  end

  def destroy
    reset_session
    redirect_to user_login_path
  end

  private

  def session_params
    params.require(:user).permit(:login, :password, :password_confirmation)
  end

  def set_current_user(user)
    session[:current_user_id] = user.id
  end

  def set_reset_user(user)
    session[:reset_user_id] = user.id
  end

end
