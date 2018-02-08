class Support::SelectsController < Support::BaseController

  def schools
    scope = School.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    schools = scope.page(params[:page])
    render json: {items: schools.as_json(only: [:id, :name])}
  end

  def bookshelf_schools
    scope = School.joins(:bookshelves).distinct.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    schools = scope.page(params[:page])
    render json: {items: schools.as_json(only: [:id, :name])}
  end

  def school_bookshelves
    scope = ProjectSeasonApplyBookshelf.pass_done.show.sorted.where("school_id = :school and classname like :q", school: "#{params[:school]}", q: "%#{params[:q]}%")
    bookshelves = scope.page(params[:page])
    render json: {items: bookshelves.as_json(only: [:id, :classname])}
  end

  def users
    scope = User.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def users_balance
    scope = User.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :user_balance)}
  end

  def gsh_child_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:gsh_child).where(gsh_children: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def teacher_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:teacher).where(teachers: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def school_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:school).where(schools: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def volunteers
    scope = Volunteer.available.enable.sorted.joins(:user).where("users.name like :q", q: "%#{params[:q]}%")
    scope = scope.where.not(id: params[:participator_ids]) if params[:participator_ids].present?
    volunteers = scope.page(params[:page])
    render json: {items: volunteers.as_json(only: [:id], methods: :volunteer_name)}
  end

  def campaign_enlist_user
    users = User.enable.sorted.where.not(users: {id: 1}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def seasons
    scope = Project.find(params[:project_id]).seasons.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    seasons = scope.page(params[:page])
    render json: {items: seasons.as_json(only: [:id, :name])}
  end

  def applies
    scope = Project.find(params[:project_id]).applies.done.sorted.where("name like :q", q: "%#{params[:q]}%")
    applies = scope.page(params[:page])
    render json: {items: applies.as_json(only: [:id, :name])}
  end


  # def income_records
  #   scope = IncomeRecord.sorted.where("name like :q", q: "%#{params[:q]}%")
  #   records = scope.page(params[:page])
  #   render json: {items: records.as_json(only: [:id, :name])}
  # end

end
