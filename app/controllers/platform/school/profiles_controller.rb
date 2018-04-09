class Platform::School::ProfilesController < Platform::School::BaseController
  def edit

  end

  def update

  end


  private
  def school_params
    params.require(:school).permit!
  end

end
