class Account::SessionsController < Account::BaseController
  skip_before_action :logged_in?

  layout 'blank'

  def new
    @user = User.new
    callback_url = callback_wechats_url(host: Settings.app_host, port: 80)
    @wechat_url = $wechat_open_client.qrcode_authorize_url(callback_url, "snsapi_login", "wechat")
  end

  def create
    @user = User.new session_params.permit!
    if session_params[:password].blank?
      flash[:alert] = '请填写密码'
      render(action: :new) && return
    end
    user = User.find_by_login(session_params[:login])
    if user.blank?
      flash[:alert] = '该帐号不存在'
      render(action: :new) && return
    end
    @user = user
    if user.state === 'disable'
      flash[:alert] = '该帐号已被停用'
      render(action: :new) && return
    end
    if user.password_digest.blank?
      flash[:alert] = '该账号还没设置密码，请用微信扫码登录。'
      render(action: :new) && return
    end
    if user.authenticate(session_params[:password])
      set_current_user(user)
      redirect_to root_path
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
        format.html {redirect_to forget_account_session_url(kind: 'by_phone'), alert: '请输入手机号'}
      else
        if params[:code].empty?
          render js: "alert('验证码不能为空');" and return
        end

        unless SmsCode.valid_code?(mobile: session_params[:login], code: params[:code], kind: 'find_password')
          render js: "alert('验证码不正确');closeCaptchaModal();refreshCaptcha();" and return
        end

        @user = User.find_by_login(session_params[:login])
        if @user.blank?
          flash[:alert] = '该帐号不存在'
          render(action: :new) && return
        else
          if @user.state === 'disable'
            flash[:alert] = '该帐号已被停用'
            render(action: :new) && return
          end
        end
        set_reset_user(@user)
        format.html {redirect_to forget_account_session_url(kind: 'edit_password')}
      end
    end
  end

  def email_get_code
    respond_to do |format|
      if session_params[:login].blank?
        format.html {redirect_to forget_account_session_url(kind: 'by_email'), alert: '请输入邮箱地址'}
      else
        @user = User.find_by_login(session_params[:login])
        if @user.blank?
          format.html {redirect_to forget_account_session_url(kind: 'by_email'), alert: '该账号不存在'}
        else
          if @user.state === 'disable'
            format.html {redirect_to forget_account_session_url(kind: 'by_email'), alert: '该账号已被停用'}
          end
        end
        #TODO:这里给所填邮箱发送验证码
        format.html {redirect_to forget_account_session_url(login: session_params[:login], kind: 'email_code')}
      end
    end
  end

  def find_back_by_email
    respond_to do |format|
      if session_params[:login].blank?
        format.html {redirect_to forget_account_session_url(kind: 'by_email'), alert: '请输入邮箱地址'}
      else
        if params[:code].empty?
          render js: "alert('验证码不能为空');" and return
        end

        unless SmsCode.valid_code?(mobile: session_params[:login], code: params[:code], kind: 'find_password')
          render js: "alert('验证码不正确');closeCaptchaModal();refreshCaptcha();" and return
        end

        @user = User.find_by_login(session_params[:login])
        if @user.blank?
          flash[:alert] = '该帐号不存在'
          render(action: :new) && return
        else
          if @user.state === 'disable'
            flash[:alert] = '该帐号已被停用'
            render(action: :new) && return
          end
        end
        set_reset_user(@user)
        format.html {redirect_to forget_account_session_url(kind: 'edit_password')}
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
        format.html { redirect_to forget_account_session_url(kind: 'edit_password'), alert: '确认密码不正确。' }
      else
        if User.find(session[:user_id]).update(password: session_params[:password])
          reset_session
          format.html { redirect_to root_path, notice: '密码已重置。' }
        else
          format.html { redirect_to forget_account_session_url(kind: 'edit_password') }
        end
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def session_params
    params.require(:user).permit(:login, :password, :password_confirmation)
  end

  def set_reset_user(user)
    session[:user_id] = user.try(:id)
    current_user = user
  end
end
