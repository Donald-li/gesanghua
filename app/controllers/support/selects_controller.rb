class Support::SelectsController < Support::BaseController

  def schools
    scope = School.enable.pass.sorted.where("name like :q", q: "%#{params[:q]}%")
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
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  def all_users
    scope = User.sorted.where("name like :q", q: "%#{params[:q]}%")
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  # 线下捐款
  def income_records
    scope = IncomeRecord.has_balance.sorted.where("title like :q", q: "%#{params[:q]}%")
    records = scope.page(params[:page])
    render json: {items: records.map{|r| {id: r.id, name: "#{r.title}(余额: #{r.balance.round(2)})"}}.as_json}
  end

  def users_balance
    scope = User.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :user_balance)}
  end

  def gsh_child_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:gsh_child).where(gsh_children: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  def teacher_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:teacher).where(teachers: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  def county_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:county_user).where(county_users: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  def school_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:school).where(schools: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  def volunteers
    scope = Volunteer.available.pass.enable.sorted.joins(:user).where("volunteers.name like :q", q: "%#{params[:q]}%")
    scope = scope.where.not(id: params[:participator_ids]) if params[:participator_ids].present?
    volunteers = scope.page(params[:page])
    render json: {items: volunteers.as_json(only: [:id], methods: :name_for_select)}
  end

  def volunteer_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:volunteer).where(volunteers: {user_id: nil}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  def campaign_enlist_user
    users = User.enable.sorted.where.not(users: {id: 1}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
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

  def majors
    scope = Major.sorted.where("name like :q", q: "%#{params[:q]}%")
    applies = scope.page(params[:page])
    render json: {items: applies.as_json(only: [:id, :name])}
  end

  def camp_funds
    funds = Project.camp_project.fund.fund_category.funds.sorted.where("name like :q", q: "%#{params[:q]}%")
    render json: {items: funds.as_json(only: [:id, :name])}
  end

  def camps
    camps = Camp.sorted.enable.where("name like :q", q: "%#{params[:q]}%")
    render json: {items: camps.as_json(only: [:id, :name])}
  end

  def camp_users
    camp_users = Camp.find(params[:camp_id]).users.sorted
    render json: {items: camp_users.as_json(only: [:id], methods: :name_for_select)}
  end

  def child_grants
    child_grants = GshChildGrant.granted.joins(:apply_child).where("title like :q or project_season_apply_children.name like :q", q: "%#{params[:q]}%").sorted
    render json: {items: child_grants.as_json(only: [:id], methods: :search_title)}
  end

  def team_manager
    unless params[:team_id].present?
      users = User.sorted.where(team_id: nil)
    else
      users = User.where(team_id: params[:team_id]) if params[:team_id].present?
    end
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  # def income_records
  #   scope = IncomeRecord.sorted.where("name like :q", q: "%#{params[:q]}%")
  #   records = scope.page(params[:page])
  #   render json: {items: records.as_json(only: [:id, :name])}
  # end

end
