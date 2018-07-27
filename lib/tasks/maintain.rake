namespace :maintain do
  task migrate_user_profile: [:environment] do
    User.all.each do |u|
      next if u.profile.blank?
      u.openid = u.profile['unionid']
      u.save
    end
  end

  task migrate_student_profile: [:environment] do
    ProjectSeasonApplyChild.sorted.each do |child|
      if child.semester_count == child.done_semester_count
        child.student_state = 'finish'
        child.save(validate: false)
      else
        child.student_state = 'normal'
        child.save(validate: false)
      end
    end
  end

  task update_donate_record_counter: [:environment] do
    Project.sorted.each do |project|
      project.update(total_amount: DonateRecord.where(project: project).sum(:amount))
    end
    Team.sorted.each do |team|
      team.update(total_donate_amount: DonateRecord.where(team: team).sum(:amount))
    end

    User.sorted.each do |user|
      user.update(promoter_amount_count: DonateRecord.where(promoter: user).sum(:amount))
    end

    School.sorted.map do |school|
      school.total_amount = DonateRecord.where(school: school).sum(:amount)
      school.save(validate: false)
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
