namespace :maintain do
  task migrate_user_profile: [:environment] do
    User.all.each do |u|
      next if u.profile.blank?
      u.openid = u.profile['unionid']
      u.save
    end
  end

  task migrate_apply_child: [:environment] do
    # ProjectSeasonApplyChild.where.not(priority_id: nil).sorted.each do |child|
    #   user_id = child.priority_id
    #   pending_grants = child.semesters.pending
    #   if pending_grants.count > 0
    #     grant = pending_grants.order(id: :asc).first
    #     if grant.title.start_with?('2018') && user_id.present?
    #       new_user_id = grant.user_id
    #       if user_id != new_user_id && new_user_id.present?
    #         child.update(priority_id: new_user_id)
    #       end
    #     end
    #   end
    # end
    count = ProjectSeasonApplyChild.count
    i = 0
    ProjectSeasonApplyChild.sorted.each do |child|
      i = i + 1
      puts "#{i} / #{count}" if i % 1000 == 0

      DonateRecord.where(project_season_apply_child_id: child.id).each do |record|
        grant = record.owner
        if record.income_record.present?
          grant.grade_name = child.enum_name(:level).to_s +  '.' + record.income_record.archive_data['Grade'].to_s
          grant.save
        end
      end
    end

    children = ProjectSeasonApplyChild.where(id: GshChildGrant.where(grade_name: nil).pluck(:project_season_apply_child_id).uniq)
    count = children.count
    i = 0
    children.each do |child|
      i = i + 1
      puts "#{i} / #{count}" if i % 500 == 0
      ok_grants = child.semesters.sorted.where.not(grade_name: nil)
      grants = child.semesters.sorted.where(grade_name: nil)
      grade = ok_grants.try(:last).try(:grade_name).try(:to_i) || 1
      grants.each do |grant|
        grant.grade_name = child.enum_name(:level).to_s +  '.' + grade.to_s
        grant.save
        grade += 1 unless grant.refund? || grant.close?
      end
    end
  end

  # 统计6月之后的收入支出到财务分类和账户
  task migrate_money: [:environment] do
    Fund.sorted.each do |fund|
      fund.update(total: IncomeRecord.can_count.where(fund: fund).sum(:amount), out_total: ExpenditureRecord.can_count.where(fund: fund).sum(:amount))
    end
    IncomeSource.sorted.each do |source|
      source.update(in_total: IncomeRecord.can_count.where(income_source: source).sum(:amount), out_total: ExpenditureRecord.can_count.where(income_source: source).sum(:amount))
    end

    Project.sorted.each do |project|
      project.update(total_amount: DonateRecord.where(project: project).sum(:amount))
    end

    IncomeRecord.update_income_history_records
    ExpenditureRecord.update_expenditure_history_records
    User.update_user_history_record

    User.enable.each {|user| user.update_columns(actived_at: user.created_at)}

    # Fund.sorted.each do |fund|
    #   fund.update(total: IncomeRecord.where(donor_id: 1).where(fund: fund).sum(:amount), out_total: ExpenditureRecord.can_count.where(fund: fund).sum(:amount))
    # end
    # IncomeSource.sorted.each do |source|
    #   source.update(in_total: IncomeRecord.where(donor_id: 1).where(income_source: source).sum(:amount), out_total: ExpenditureRecord.can_count.where(income_source: source).sum(:amount))
    # end

    Project.update_all(management_rate: 10)
  end
end
