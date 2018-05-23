class Site::VolunteersController < Site::BaseController

  def index
    @search = Volunteer.ransack(params[:q])
    scope = @search.result
    scope = scope.page(params[:page]).per(12)
    @volunteers = scope.sorted
  end

end
