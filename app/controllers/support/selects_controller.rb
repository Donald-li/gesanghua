class Support::SelectsController < Support::BaseController

  def schools
    scope = School.enable.pass.sorted.where("name like :q", q: "%#{params[:q]}%")
    schools = scope.page(params[:page])
    render json: {items: schools.as_json(only: [:id, :name]), pagination: json_pagination(schools)}
  end

  def bookshelf_schools
    scope = School.joins(:bookshelves).distinct.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    schools = scope.page(params[:page])
    render json: {items: schools.as_json(only: [:id, :name]), pagination: json_pagination(schools)}
  end

  def school_bookshelves
    scope = ProjectSeasonApplyBookshelf.pass_done.show.sorted.where("school_id = :school and classname like :q", school: "#{params[:school]}", q: "%#{params[:q]}%")
    bookshelves = scope.page(params[:page])
    render json: {items: bookshelves.as_json(only: [:id, :classname]), pagination: json_pagination(bookshelves)}
  end

  def users
    scope = User.enable.sorted.where("name like :q or nickname like :q or phone like :q or id = :user_id", q: "%#{params[:q]}%", user_id: params[:q].to_i)
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  def all_users
    scope = User.sorted.where("name like :q or nickname like :q or phone like :q or id = :user", q: "%#{params[:q]}%", user: params[:q].to_i)
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users) }
  end

  def wechat_users
    scope = User.where.not(profile: {})
    scope = scope.where(id: params[:user_id]) if params[:user_id].present?
    scope = scope.sorted.where("name like :q or nickname like :q or phone like :q or id = :user", q: "%#{params[:q]}%", user: params[:q].to_i)
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  # 线下捐款
  def income_records
    scope = IncomeRecord.offline.has_balance.sorted.joins(:donor).where("title like :q or users.nickname like :q or users.name like :q", q: "%#{params[:q]}%")
    records = scope.page(params[:page])
    render json: {items: records.map{|r| {id: r.id, name: "#{r.title}(捐助人：#{r.donor.try(:name)}|代捐人：#{r.agent_name}|余额: #{r.balance.round(2)})"}}.as_json, pagination: json_pagination(records)}
  end

  def users_balance
    scope = User.sorted.where("name like :q or nickname like :q or phone like :q", q: "%#{params[:q]}%")
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :user_balance), pagination: json_pagination(users)}
  end

  def gsh_child_user
    users = User.sorted.where.not(users: {id: 1}).left_joins(:gsh_child).where(gsh_children: {user_id: nil}).where("users.name like :q or users.nickname like :q or users.phone like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  def teacher_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:teacher).where(teachers: {user_id: nil}).where("users.name like :q or users.nickname like :q or users.phone like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  def county_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:county_user).where(county_users: {user_id: nil}).where("users.name like :q or users.nickname like :q or users.phone like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  def school_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:school).where(schools: {user_id: nil}).where("users.name like :q or users.nickname like :q or users.phone like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  def volunteers
    scope = Volunteer.available.pass.enable.sorted.joins(:user).where("volunteers.name like :q", q: "%#{params[:q]}%")
    scope = scope.where.not(id: params[:participator_ids]) if params[:participator_ids].present?
    volunteers = scope.page(params[:page])
    render json: {items: volunteers.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(volunteers)}
  end

  def volunteer_user
    users = User.enable.sorted.where.not(users: {id: 1}).left_joins(:volunteer).where(volunteers: {user_id: nil}).where("users.name like :q or users.nickname like :q or users.phone like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  def campaign_enlist_user
    users = User.enable.sorted.where.not(users: {id: 1}).where("users.name like :q or users.nickname like :q or users.phone like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  def seasons
    scope = Project.find(params[:project_id]).seasons.enable.sorted.where("name like :q", q: "%#{params[:q]}%")
    seasons = scope.page(params[:page])
    render json: {items: seasons.as_json(only: [:id, :name]), pagination: json_pagination(seasons)}
  end

  def applies
    scope = Project.find(params[:project_id]).applies.done.sorted.where("name like :q", q: "%#{params[:q]}%")
    applies = scope.page(params[:page])
    render json: {items: applies.as_json(only: [:id, :name]), pagination: json_pagination(applies)}
  end

  def majors
    scope = Major.sorted.where("name like :q", q: "%#{params[:q]}%")
    applies = scope.page(params[:page])
    render json: {items: applies.as_json(only: [:id, :name]), pagination: json_pagination(applies)}
  end

  def camps
    camps = Camp.sorted.enable.where("name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: camps.as_json(only: [:id, :name]), pagination: json_pagination(camps)}
  end

  def camp_users
    scope = User.sorted.where("name like :q or nickname like :q or phone like :q", q: "%#{params[:q]}%")
    scope = scope.where(camp_id: params[:camp_id]) if params[:camp_id].present?
    users = scope.page(params[:page])
    render json: {items: users.as_json(only: [:id, :name], methods: :select_with_role_names), pagination: json_pagination(users)}
  end

  def child_grants
    scope = GshChildGrant.granted.joins(:apply_child, :gsh_child).where("title like :q or project_season_apply_children.name like :q or gsh_children.gsh_no like :q or project_season_apply_children.id_card like :q", q: "%#{params[:q]}%").reverse_sorted
    child_grants = scope.page(params[:page])
    render json: {items: child_grants.as_json(only: [:id], methods: :search_title), pagination: json_pagination(child_grants)}
  end

  def team_manager
    unless params[:team_id].present?
      users = User.sorted.where(team_id: nil)
    else
      users = User.where(team_id: params[:team_id]) if params[:team_id].present?
    end
    users = users.page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(users)}
  end

  # def income_records
  #   scope = IncomeRecord.sorted.where("name like :q", q: "%#{params[:q]}%")
  #   records = scope.page(params[:page])
  #   render json: {items: records.as_json(only: [:id, :name])}
  # end

  def funds
    fund_category = FundCategory.find_by(id: params[:fund_category_id])
    if fund_category.present?
      scope = fund_category.funds.sorted.where("name like :q", q: "%#{params[:q]}%")
      funds = scope.page(params[:page])
      render json: {items: funds.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(funds)}
    else
      funds = Fund.where(id: nil).page(params[:page])
      render json: {items: funds.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(funds)}
    end
  end

  def grant_children
    ids = ProjectSeasonApplyChild.where(project: Project.pair_project).joins(:semesters)
              .where(gsh_child_grants: {donate_state: :pending})
              .select("distinct project_season_apply_children.id").pluck(:id).uniq
    children = ProjectSeasonApplyChild.where(id: ids).includes(:gsh_child).pass.sorted.page(params[:page])
    render json: {items: children.as_json(only: [:id], methods: :name_for_select), pagination: json_pagination(children)}
  end

end
