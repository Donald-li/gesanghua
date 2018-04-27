class Account::UserCenter::ProfilesController < Account::BaseController
  layout 'account_user_center'

  def edit
    @profile = current_user
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        current_user.attach_avatar(params[:avatar_id])
        format.html { redirect_to edit_account_user_center_profile_path, notice: '用户资料已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end

end
