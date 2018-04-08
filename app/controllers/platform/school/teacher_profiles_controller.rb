class Platform::School::TeacherProfilesController < Platform::School::BaseController
  layout 'platform_school_blank'
  def edit

  end

  def update

  end


  private
  def school_params
    params.require(:school).permit!
  end

end
