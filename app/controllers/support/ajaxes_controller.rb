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
    render json: {items: users.as_json(only: [:id, :name])}
  end

  def user_statistics
    user_statistics = StatisticRecord.user_register.record_sorted
    user_statistics = user_statistics.where("record_time > ? and record_time < ?", Time.now.beginning_of_day - 1.week, Time.now.end_of_day) if params[:time_span] == 'week'
    user_statistics = user_statistics.where("record_time > ? and record_time < ?", Time.now.beginning_of_day - 1.month, Time.now.end_of_day) if params[:time_span] == 'month'
    user_statistics = user_statistics.where("record_time > ? and record_time < ?", Time.now.beginning_of_day - 1.year, Time.now.end_of_day) if params[:time_span] == 'year'
    user_statistics = user_statistics.where("record_time > ?", params[:start_time]) if params[:start_time].present?
    user_statistics = user_statistics.where("record_time < ?", params[:end_time]) if params[:end_time].present?

    hash = user_statistics.map {|item| [item.record_time.strftime("%Y-%m-%d"), item.amount]}.to_h
    render json: {keys: hash.keys, values: hash.values}
  end

  def income_statistics
    income_statistics = StatisticRecord.income_statistic.record_sorted
    income_statistics = income_statistics.where("record_time > ? and record_time < ?", Time.now.beginning_of_day - 1.week, Time.now.end_of_day) if params[:time_span] == 'week'
    income_statistics = income_statistics.where("record_time > ? and record_time < ?", Time.now.beginning_of_day - 1.month, Time.now.end_of_day) if params[:time_span] == 'month'
    income_statistics = income_statistics.where("record_time > ? and record_time < ?", Time.now.beginning_of_day - 1.year, Time.now.end_of_day) if params[:time_span] == 'year'
    income_statistics = income_statistics.where("record_time > ?", params[:start_time]) if params[:start_time].present?
    income_statistics = income_statistics.where("record_time < ?", params[:end_time]) if params[:end_time].present?

    hash = income_statistics.map {|item| [item.record_time.strftime("%Y-%m-%d"), item.amount]}.to_h
    render json: {keys: hash.keys, values: hash.values}
  end

  def bill_amount
    ids = params[:ids]
    amount = DonateRecord.count_amount(ids)
    render json: {value: amount}
  end

  def submit_pair_children
    @apply = ProjectSeasonApply.find(params[:id])
    @children = ProjectSeasonApplyChild.where(id: params[:child_ids])
    if @children.map(&:submit!) && @apply.waiting_check!
      render json: {message: '提交成功，请耐心等待审核', status: true}
    else
      render json: {message: '提交失败，请重试', status: false}
    end
  end

  def submit_camp_members
    @camp = ProjectSeasonApplyCamp.find(params[:id])
    @members = ProjectSeasonApplyCampMember.where(id: params[:child_ids])
    if @members.map(&:submit!) && @camp.to_approve!
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

end
