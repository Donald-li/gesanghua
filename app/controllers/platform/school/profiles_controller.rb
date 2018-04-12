class Platform::School::ProfilesController < Platform::School::BaseController

  def edit
    @profile = current_user.school
  end

  def update
    @profile = current_user.school
    if @profile.update_attributes(school_params.merge(province: params[:user][:province], city: params[:user][:city], district: params[:user][:district]))
      @profile.attach_logo(params[:logo_id])
      flash[:notice] = '修改成功。'
      gen_success_message
    else
      flash[:notice] = @profile.errors.full_messages
      gen_failure_message(@profile)
    end
  end

  private

  def school_params
    params.require(:school).permit!
  end

end
