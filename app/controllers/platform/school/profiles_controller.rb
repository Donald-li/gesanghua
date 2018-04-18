class Platform::School::ProfilesController < Platform::School::BaseController

  def edit
    @profile = current_user.school
  end

  def update
    @profile = current_user.school
    respond_to do |format|
      if @profile.update_attributes(school_params.merge(province: params[:user][:province],
                                                        city: params[:user][:city],
                                                        district: params[:user][:district]))
        @profile.attach_logo(params[:logo_id])
        format.html {redirect_to edit_platform_school_profile_path, notice: '修改成功。'}
      else
        format.html {render :new, notice: @profile.errors.full_messages}
      end
    end
  end

  private

  def school_params
    params.require(:school).permit!
  end

end
