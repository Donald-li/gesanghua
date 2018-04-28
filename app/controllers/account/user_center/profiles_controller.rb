class Account::UserCenter::ProfilesController < Account::BaseController
  layout 'account_user_center'
  before_action :set_profile, only: [:edit, :update]

  def edit
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        current_user.attach_avatar(params[:avatar_id])
        format.html { redirect_to edit_account_user_center_profile_path, notice: '用户资料已修改。' }
      else
        format.html { render :edit, notice: @profile.errors.full_messages.first}
      end
    end
  end

  private
  def set_profile
    @profile = current_user
  end

  def user_params
    params.require(:user).permit!
  end

end
