namespace :maintain do
  task migrate_user_profile: [:environment] do
    User.all.each do |u|
      next if u.profile.blank?
      u.openid = u.profile['unionid']
      u.save
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

    IncomeRecord.update_expenditure_history_records
    ExpenditureRecord.update_expenditure_history_records
    User.update_user_history_record

    # Fund.sorted.each do |fund|
    #   fund.update(total: IncomeRecord.where(donor_id: 1).where(fund: fund).sum(:amount), out_total: ExpenditureRecord.can_count.where(fund: fund).sum(:amount))
    # end
    # IncomeSource.sorted.each do |source|
    #   source.update(in_total: IncomeRecord.where(donor_id: 1).where(income_source: source).sum(:amount), out_total: ExpenditureRecord.can_count.where(income_source: source).sum(:amount))
    # end

    Project.update_all(management_rate: 10)
  end
end
