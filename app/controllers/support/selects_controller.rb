class Support::SelectsController < Support::BaseController

  def schools
    scope = School.enabled.where("name like :q", q: "%#{params[:q]}%")
    schools = scope.page(params[:page])
    render json: {items: schools.as_json(only: [:id, :name])}
  end

end
