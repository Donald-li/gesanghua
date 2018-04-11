class Platform::School::ProfilesController < Platform::School::BaseController
  def edit
    #binding.pry
    @profile = School.first#find_by_id(params[:id])
  end

  def update

  end


  private

  def school_params
    params.require(:school).permit!
  end

end
