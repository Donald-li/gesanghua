class Support::AjaxesController < Support::BaseController
  def branches
    if params[:branch_id].present?
      @search = Branch.where.not(id: params[:branch_id]).normal.ransack(params[:q])
    else
      @search = Branch.normal.ransack(params[:q])
    end
    scope = @search.result
    branches = scope.includes('logo').sorted.page(params[:page]).per(10)
    render json: {branches: branches.as_json(only: [:id, :name], methods: [:simple_address, :users_count, :groups_count, :children_count, :is_complete?, :logo_url, :leader_name, :leader_avatar]), pagination: json_pagination(branches)}
  end

  def school_users
    users = User.enable.where.not(users: {id: 1}).where("users.name like :q", q: "%#{params[:q]}%").page(params[:page])
    render json: {items: users.as_json(only: [:id], methods: :name_for_select)}
  end

  def user_statistics
    user_statistics = User.enable
    if params[:time_span].present?
      params[:start_time] = Time.now.beginning_of_week if params[:time_span] == 'week'
      params[:start_time] = Time.now.beginning_of_month if params[:time_span] == 'month'
      params[:start_time] = Time.now.beginning_of_year if params[:time_span] == 'year'
    end
    params[:start_time] = Time.now.beginning_of_month unless params[:start_time].present?
    user_statistics = user_statistics.where("actived_at >= ?", params[:start_time])
    user_statistics = user_statistics.where("actived_at <= ?", params[:end_time]) if params[:end_time].present?
    user_statistics = user_statistics.select("count (*), date_trunc('day', actived_at) as day").group("day").order("day asc")

    hash = user_statistics.map {|item| [item['day'].strftime("%Y-%m-%d"), item['count']]}.to_h
    render json: {keys: hash.keys, values: hash.values}
  end

  def income_statistics
    income_statistics = IncomeRecord.all
    if params[:time_span].present?
      params[:start_time] = Time.now.beginning_of_week if params[:time_span] == 'week'
      params[:start_time] = Time.now.beginning_of_month if params[:time_span] == 'month'
      params[:start_time] = Time.now.beginning_of_year if params[:time_span] == 'year'
    end
    params[:start_time] = Time.now.beginning_of_month unless params[:start_time].present?
    income_statistics = income_statistics.where("income_time >= ?", params[:start_time])
    income_statistics = income_statistics.where("income_time <= ?", params[:end_time]) if params[:end_time].present?
    income_statistics = income_statistics.select("sum (amount) as total, date_trunc('day', income_time) as day").group("day").order("day asc")

    hash = income_statistics.map {|item| [item['day'].strftime("%Y-%m-%d"), item['total']]}.to_h
    render json: {keys: hash.keys, values: hash.values}
  end

  # TODO: ken
  def bill_amount
    ids = params[:ids]
    amount = IncomeRecord.count_amount(ids)
    render json: {value: amount}
  end

  def submit_pair_children
    @apply = ProjectSeasonApply.find(params[:id])
    @children = ProjectSeasonApplyChild.where(id: params[:child_ids])
    if @children.update_all(approve_state: 'submit', submit_at: Time.now) && @apply.waiting_check!
      render json: {message: '提交成功，请耐心等待审核', status: true}
    else
      render json: {message: '提交失败，请重试', status: false}
    end
  end

  def submit_camp_members
    @camp = ProjectSeasonApplyCamp.find(params[:id])
    @members = ProjectSeasonApplyCampMember.where(id: params[:member_ids])
    if @members.update_all(state: 'submit') && @camp.to_approve!
      render json: {message: '提交成功，请耐心等待审核', status: true}
    else
      render json: {message: '提交失败，请重试', status: false}
    end
  end

  def submit_member_reason
    @member = ProjectSeasonApplyCampMember.find(params[:member_id])
    @member.reason = params[:reason]
    if @member.save
      render json: {message: '保存成功', status: true}
    else
      render json: {message: '保存失败，请重试', status: false}
    end
  end

  def submit_child_reason
    @child = ProjectSeasonApplyChild.find(params[:child_id])
    @child.reason = params[:reason]
    if @child.save
      render json: {message: '保存成功', status: true}
    else
      render json: {message: '保存失败，请重试', status: false}
    end
  end

  def create_read_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.new(
        classname: params[:classname],
        student_number: params[:number],
        school: current_user.school,
        province: current_user.school.try(:province),
        city: current_user.school.try(:city),
        district: current_user.school.try(:district),
        project: Project.read_project
    )
    if @bookshelf.save
      render json: {message: '保存成功', status: true, bookshelf: @bookshelf}
    else
      render json: {message: '保存失败，请重试', status: false}
    end
  end

  def edit_read_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    if @bookshelf.present?
      render json: {message: '获取成功', status: true, bookshelf: @bookshelf}
    else
      render json: {message: '获取失败，请重试', status: false}
    end
  end

  def update_read_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    if @bookshelf.update(classname: params[:classname], student_number: params[:number])
      render json: {message: '修改成功', status: true, bookshelf: @bookshelf}
    else
      render json: {message: '修改失败，请重试', status: false}
    end
  end

  def delete_read_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    if @bookshelf.destroy
      render json: {message: '删除成功', status: true}
    else
      render json: {message: '删除失败，请重试', status: false}
    end
  end

  def new_read_supplement
    @school = current_user.teacher.school
    @bookshelves = @school.bookshelves.where.not(id: params[:bookshelf_ids]).pass_done
    if @bookshelves.present?
      render json: {message: '获取成功', status: true, bookshelves: @bookshelves}
    else
      render json: {message: '没有可补书班级', status: false}
    end
  end

  def create_read_supplement
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:bookshelf_id])
    @supplement = @bookshelf.supplements.new
    @supplement.loss = params[:loss]
    @supplement.supply = params[:supply]
    if @supplement.save
      render json: {message: '保存成功', status: true, supplement: @supplement, bookshelf: @bookshelf}
    else
      render json: {message: '保存失败，请重试', status: false}
    end
  end

  def edit_read_supplement
    @supplement = BookshelfSupplement.find(params[:supplement_id])
    @bookshelf = @supplement.bookshelf
    if @supplement.present?
      render json: {message: '获取成功', status: true, supplement: @supplement, bookshelf: @bookshelf}
    else
      render json: {message: '获取失败，请重试', status: false}
    end
  end

  def update_read_supplement
    @supplement = BookshelfSupplement.find(params[:supplement_id])
    @bookshelf = @supplement.bookshelf
    if @supplement.update(loss: params[:loss], supply: params[:supply])
      render json: {message: '修改成功', status: true, supplement: @supplement, bookshelf: @bookshelf}
    else
      render json: {message: '修改失败，请重试', status: false}
    end
  end

  def delete_read_supplement
    @supplement = BookshelfSupplement.find(params[:supplement_id])
    if @supplement.destroy
      render json: {message: '删除成功', status: true}
    else
      render json: {message: '删除失败，请重试', status: false}
    end
  end

  def dismiss_team
    @team = Team.find(params[:team_id])
    if @team.users.update(team_id: nil) && @team.dismiss!
      render json: {message: '解散成功', status: true}
    else
      render json: {message: '解散失败，请重试', status: false}
    end
  end

  def turn_team
    @team = Team.find(params[:team_id])
    @user = User.find(params[:user_id])
    if @user.present? && @team.update(manager: @user)
      render json: {message: '移交成功', status: true}
    else
      render json: {message: '移交失败，请重试', status: false}
    end
  end

  def get_child_priority
    @child = ProjectSeasonApplyChild.find(params[:child_id])
    donor = User.find(params[:donor_id])
    if @child.priority_id.present? and donor.id != @child.priority_id and !donor.offline_users.pluck(:id).include?(@child.priority_id) and @child.hidden?
      render json: {message: '被捐助学生已被指定优先捐助人，请联系管理员处理', status: false}
    elsif Donation.where(owner: @child).where('created_at > :time', time: Time.now - 0.5.hours).where.not(agent_id: donor.id).present?
      render json: {message: '该孩子有人正在捐助，请稍后再试或看看其他孩子', status: false}
    else
      render json: {message: '可捐助', status: true}
    end
  end

  def set_shelf_name
    bookshelf = ProjectSeasonApplyBookshelf.find_by(id: params[:bookshelf_id])
    if bookshelf.update(title: params[:name])
      render json: {message: '署名成功', status: true}
    else
      render json: {message: '署名失败，请重试', status: false}
    end
  end

  def add_all_grants
    @batch = GrantBatch.find(params[:id])
    scope = GshChildGrant.waiting.succeed.where(grant_batch_id: nil).joins(:gsh_child).order("gsh_children.gsh_no asc")
    scope = scope.where("title like :q", q: "%#{params[:title]}%") if params[:title].present?
    scope = scope.where(school_id: params[:school_id]) if params[:school_id].present?
    scope = scope.where("gsh_children.name like :q or gsh_children.gsh_no like :q", q: "%#{params[:keyword]}%") if params[:keyword].present? # gsh_child_name_or_gsh_child_gsh_no_cont
    @grants = scope.sorted
    if @grants.count > 0
      @grants.update_all(grant_batch_id: @batch.id)
      render json: {message: '署名成功', status: true}
    else
      render json: {message: '搜索范围内没有可发放学年', status: false}
    end
  end

  def batch_accrue
    @can_accrue_grants = GshChildGrant.where(id: params[:grant_ids])
    total_count = @can_accrue_grants.count
    success_count = 0
    fail_count = 0
    @can_accrue_grants.each do |grant|
      @project = Project.pair_project
      @rate = @project.management_rate
      if ManagementFee.accrue_management_fee(
          owner_type: grant.class.name,
          owner_id: grant.id,
          total_amount: grant.target_amount,
          fund_id: @project.fund_id,
          amount: format('%.2f', grant.target_amount * @rate / (100 + @rate)),
          user: current_user)
        success_count += 1
      else
        fail_count += 1
      end
    end
    render json: {message: "共计#{total_count}条，成功#{success_count}条，失败#{fail_count}条。3秒后自动刷新页面"}
  end

  def search_wechat_user
    users = User.where.not(profile: {})
    users = users.where(province: params[:province]) if params[:province].present?
    users = users.where(province: params[:province], city: params[:city]) if params[:city].present?
    users = users.where(province: params[:province], city: params[:city], district: params[:district]) if params[:district].present?
    render json: {user_ids: users.pluck(:id), count: users.count}
  end

end
