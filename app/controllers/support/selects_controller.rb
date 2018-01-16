class Support::SelectsController < Support::BaseController

  def schools
    scope = School.enable.where("name like :q", q: "%#{params[:q]}%")
    schools = scope.page(params[:page])
    render json: {items: schools.as_json(only: [:id, :name])}
  end

  def users
  end

  def gsh_child_user
    users = User.enable.where.not(users: {id: 1}).left_joins(:gsh_child).where(gsh_children: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def teacher_user
    users = User.enable.where.not(users: {id: 1}).left_joins(:teacher).where(teachers: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def school_user
    users = User.enable.where.not(users: {id: 1}).left_joins(:school).where(schools: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def volunteers
    scope = Volunteer.available.enable.joins(:user).where("users.name like :q", q: "%#{params[:q]}%")
    scope = scope.where.not(id: params[:participator_ids]) if params[:participator_ids].present?
    volunteers = scope.page(params[:page])
    render json: {items: volunteers.as_json(only: [:id], methods: :volunteer_name)}
  end

  def campaign_enlist_user
    users = User.enable.where.not(users: {id: 1}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

end
