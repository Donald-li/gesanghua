class Account::RegistrationsController < Account::BaseController
  skip_before_action :login_require, only: [:new, :create]

  layout 'blank'

  def new
    @user = User.new
    callback_url = callback_wechats_url(host: Settings.app_host, port: 80)
    @wechat_url = $wechat_open_client.qrcode_authorize_url(callback_url, "snsapi_login", "wechat")
  end

  def create
    respond_to do |format|
      if !user_params[:login].present?
        format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: params[:kind] == 'by_phone' ? '请填写手机号' : '请填写邮箱'}
      elsif !user_params[:password].present?
        format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: '请填写密码'}
      elsif !user_params[:nickname].present?
        format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: '请填写昵称'}
      else
        user = User.find_by_login(user_params[:login])
        if user.present?
          if user.state != 'unactived'
            format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: params[:kind] == 'by_phone'? '手机号已注册。' : '邮箱已注册。'}
          elsif user.state == 'unactived' && user.manager_id.present?
            if user.offline_user_activation(user.phone, nil) && user.update(user_params)
              set_current_user(user)
              format.html { redirect_to root_path, notice: '账号成功激活。' }
            else
              format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: user.errors.full_messages}
            end
          end
        else
          if params[:protocol] != 'on'
            format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: '请同意《格桑花用户注册协议》。'}
          end
          if params[:code].empty?
            format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: '验证码不能为空。'}
          end

          unless SmsCode.valid_code?(mobile: user_params[:login], code: params[:code], kind: 'signup')
            format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: '验证码错误。'}
          end
          @user = User.new(user_params)
          @user.name ||= user_params[:login]
          if params[:kind] == 'by_phone'
            @user.phone = user_params[:login]
          else
            @user.email = user_params[:login]
          end
          if @user.save
            set_current_user(@user)
            format.html { redirect_to root_path, notice: '注册成功。' }
          else
            format.html {redirect_to new_account_registration_url(kind: params[:kind]), alert: @user.errors.full_messages}
          end
        end
      end
    end
  end

  def show
  end

  def bind

  end

  private
    def user_params
      params.require(:user).permit!
    end

    def set_current_user(user)
      session[:user_id] = user.id
    end

end
