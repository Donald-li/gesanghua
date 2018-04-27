class Account::UserCenter::AccountsController < Account::BaseController
  layout 'account_user_center'

  before_action :set_user

  def show
  end

  def edit_phone
  end

  def update_phone
    if params[:code].empty?
      redirect_to edit_phone_account_user_center_account_path, alert: '验证码不能为空。' and return
    end
    unless params[:new_password] === params[:confirm_password] && params[:new_password].present?
      redirect_to edit_phone_account_user_center_account_path, alert: '确认密码错误。' and return
    end
    unless SmsCode.valid_code?(mobile: params[:phone], code: params[:code], kind: 'signup')
      redirect_to edit_phone_account_user_center_account_path, alert: '验证码错误。' and return
    end
    if User.find_by(phone: params[:phone])
      redirect_to edit_phone_account_user_center_account_path, alert: '手机号已占用。' and return
    else
      @user.phone = params[:phone]
      @user.password = params[:new_password]
      if @user.save
        @user.bind_user_roles
        redirect_to account_user_center_account_path, notice: '手机号绑定成功。' and return
      else
        redirect_to edit_phone_account_user_center_account_path, alert: @user.errors.full_messages.join(',')
      end
    end
  end

  def change_phone
  end

  def update_change_phone
    if params[:code].empty?
      redirect_to change_phone_account_user_center_account_path, alert: '验证码不能为空。' and return
    end
    unless SmsCode.valid_code?(mobile: params[:phone], code: params[:code], kind: 'signup')
      redirect_to change_phone_account_user_center_account_path, alert: '验证码错误。' and return
    end
    if User.find_by(phone: params[:phone])
      redirect_to change_phone_account_user_center_account_path, alert: '手机号已占用。' and return
    else
      @user.phone = params[:phone]
      if @user.save
        @user.bind_user_roles
        redirect_to account_user_center_account_path, notice: '手机号修改成功。' and return
      else
        redirect_to change_phone_account_user_center_account_path, alert: @user.errors.full_messages.join(',')
      end
    end

  end

  def edit_password
  end

  def update_password
    if @user.password_digest.present? && !@user.authenticate(params[:old_password])
      redirect_to edit_password_account_user_center_account_path, notice: '原密码错误。' and return
    elsif params[:new_password] != params[:confirm_password] || params[:new_password].empty?
      redirect_to edit_password_account_user_center_account_path, notice: '确认密码错误。' and return
    else
      @user.password = params[:new_password]
      if @user.save
        redirect_to account_user_center_account_path, notice: '密码修改成功。' and return
      else
        redirect_to edit_password_account_user_center_account_path, alert: @user.errors.full_messages.join(',')
      end
    end
  end

  private
  def set_user
    @user = current_user
  end

end
