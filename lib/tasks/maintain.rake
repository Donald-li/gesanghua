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

    ProjectSeasonApplyChild.all.each do |child|
      gsh_child = child.gsh_child
      apply = child.apply
      season = apply.season
      level = child.enum_name(:level)

      if child.junior?
        term_amount = season.junior_term_amount
        year_amount = season.junior_year_amount
      elsif child.senior?
        term_amount = season.senior_term_amount
        year_amount = season.senior_year_amount
      end

      apply_num = 4 - child.child_grade_integer

      year = Time.now.year

      if child.next_term? && apply_num > 0
        grant = GshChildGrant.find_by(title: "#{year}.3 - #{year}.7 学期", gsh_child: gsh_child, apply_child: child, apply: apply, amount: term_amount, school_id: child.school_id)
        grant.update(grade_name: "#{level}#{child.enum_name(:grade)}")
        apply_num -= 1
        child.grade = ProjectSeasonApplyChild.grades[child.grade] + 1
      end

      if (apply_num > 0)
        apply_num.times do
          grant = GshChildGrant.find_or_create_by(title: "#{year}.9 - #{year + 1}.7 学年", gsh_child: gsh_child, apply_child: child, apply: apply, amount: year_amount, school_id: child.school_id)
          grant.update(grade_name: "#{level}#{child.enum_name(:grade)}")
          year += 1
          child.grade = ProjectSeasonApplyChild.grades[child.grade] + 1
        end
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
