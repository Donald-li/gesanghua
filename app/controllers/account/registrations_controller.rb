class Account::RegistrationsController < Account::BaseController
  skip_before_action :logged_in?, only: [:new, :create]

  layout 'blank'

  def new
    @user = User.new
  end

  def create
    # @user = User.new(user_params)
    respond_to do |format|
      # format.html {redirect_to new_account_registration_url, alert: '验证码不能为空。'}
      # format.html {redirect_to new_account_registration_url, notice: '验证码不能为空。'}
      format.html {
        flash[:notice] = '验证码不能为空。'
        render 'new'
      }
      # if params[:code].empty?
      #   format.html {redirect_to new_account_registration_url, alert: '验证码不能为空。'}
      # end
      #
      # unless SmsCode.valid_code?(mobile: user_params[:login], code: params[:code].to_i)
      #   format.html {redirect_to new_account_registration_url, alert: '验证码错误。'}
      # end
      #
      # if User.find_by(login: user_params[:login])
      #   format.html {redirect_to new_account_registration_url, alert: '手机号已注册。'}
      # else
      #   if @user.save
      #     set_current_user(@user)
      #     format.html { redirect_to account_registration_path, article: '注册成功。' }
      #   else
      #     format.html { render :new }
      #   end
      # end
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
