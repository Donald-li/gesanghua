# -*- encoding : utf-8 -*-
require 'roo'

class FileUtil

  def self.import_income_records(original_filename: nil, path: nil)
    s = nil
    if File.extname(original_filename) == '.xlsx'
      s = Roo::Excelx.new path
    else
      return {status: false, message: "格式不支持"}
    end

    2.upto(s.last_row) do |line|

      title = s.formatted_value(line, 'A')
      fund_title = s.formatted_value(line, 'B')
      income_time = s.cell(line, 'C')
      amount = s.formatted_value(line, 'D')
      income_source_name = s.formatted_value(line, 'E')
      donor = s.formatted_value(line, 'F')
      donor_phone = s.formatted_value(line, 'G')
      agent_name = s.formatted_value(line, 'H')
      agent_phone = s.formatted_value(line, 'I')
      remark = s.formatted_value(line, 'J')

      fund = fund_title.present? ? FundCategory.find_by(name: fund_title.split('-').first).funds.find_by(name: fund_title.split('-').second) : nil
      income_source = IncomeSource.find_by(name: income_source_name) || nil

      donor = User.find_by(phone: donor_phone)
      agent = User.find_by(phone: agent_phone)

      if fund.present?
        income_time = income_time.class.to_s == 'DateTime' || income_time.class.to_s == 'Date' ? income_time : Time.parse(income_time)
        IncomeRecord.create(kind: 'offline', title: title, fund: fund, income_time: income_time, amount: amount, income_source: income_source, agent: agent, donor: donor, remark: remark)
      end

    end
  end

  def self.import_expenditure_records(original_filename: nil, path: nil)
    s = nil
    s_count = 0
    f_count = 0
    if File.extname(original_filename) == '.xlsx'
      s = Roo::Excelx.new path
    else
      return {status: false, message: "格式不支持"}
    end
    #  name：学校名称  contact_name：联系人姓名 contact_title：联系人职位 contact_phone：联系方式 province：省 city：市 district：区 street：街 address：详细地址
    2.upto(s.last_row) do |line|

      name = s.formatted_value(line, 'A')
      expended_at = s.cell(line, 'B')
      fund_title = s.formatted_value(line, 'C')
      # ledger_name = s.formatted_value(line, 'C')
      income_source_name = s.formatted_value(line, 'D')
      amount = s.formatted_value(line, 'E')
      remark = s.formatted_value(line, 'F')
      operator = s.formatted_value(line, 'G')

      fund = fund_title.present? ? FundCategory.find_by(name: fund_title.split('-').first).funds.find_by(name: fund_title.split('-').second) : nil
      # ledger = ledger_name.present? ? ExpenditureLedger.find_by(name: ledger_name) : nil
      income_source = IncomeSource.find_by(name: income_source_name) || nil

      if fund.present?
        expended_at = expended_at.class.to_s == 'DateTime' || expended_at.class.to_s == 'Date' ? expended_at : Time.parse(expended_at)
        ExpenditureRecord.create(fund: fund, income_source: income_source, expended_at: expended_at, amount: amount, operator: operator, name: name, remark: remark)
        # ExpenditureRecord.create(expenditure_ledger: ledger, expended_at: expended_at, amount: amount, operator: operator, name: name, remark: remark)
        s_count += 1
      else
        f_count += 1
      end
    end
    # right_notice = "成功录入#{s_count}条，其中#{f_count}条录入失败"
    right_notice = "成功录入#{s_count}条支出记录"
  end

  def self.import_beneficial_children_records(original_filename: nil, path: nil, apply_id: nil, project_season_apply_bookshelf_id: nil)
    s = nil
    if File.extname(original_filename) == '.xlsx'
      s = Roo::Excelx.new path
    else
      return {status: false, message: "格式不支持"}
    end

    @apply = ProjectSeasonApply.find(apply_id)

    2.upto(s.last_row) do |line|

      name = s.formatted_value(line, 'A')
      gender = s.cell(line, 'B')
      id_no = s.formatted_value(line, 'C')
      nation = s.formatted_value(line, 'D')

      if gender == '男'
        gender = 1
      elsif gender == '女'
        gender = 2
      else
        gender = ''
      end

      nation = BeneficialChild.nation_hash_name(nation)

      BeneficialChild.create(project_season_apply: @apply, project_season_apply_bookshelf_id: project_season_apply_bookshelf_id, name: name, gender: gender, id_no: id_no, nation: nation)
    end
  end


  def self.import_pair_students(original_filename: nil, path: nil, project_apply: nil)
    s = nil
    if File.extname(original_filename) == '.xlsx'
      s = Roo::Excelx.new path
    else
      return {status: false, message: "格式不支持"}
    end
    child_ids = []
    2.upto(s.last_row) do |line|

      index = s.formatted_value(line, 'A')
      name = s.formatted_value(line, 'B')
      id_card = s.cell(line, 'C')
      nation = s.formatted_value(line, 'D')
      level = s.formatted_value(line, 'E')
      grade = s.formatted_value(line, 'F')
      semester = s.formatted_value(line, 'G')
      teacher_name = s.formatted_value(line, 'H')
      teacher_phone = s.formatted_value(line, 'I')
      description = s.formatted_value(line, 'J')
      father = s.formatted_value(line, 'K')
      father_job = s.formatted_value(line, 'L')
      mother = s.formatted_value(line, 'M')
      mother_job = s.formatted_value(line, 'N')
      parent_information = s.formatted_value(line, 'O')
      guardian = s.formatted_value(line, 'P')
      guardian_relation = s.formatted_value(line, 'Q')
      guardian_phone = s.formatted_value(line, 'R')
      address = s.formatted_value(line, 'S')
      family_income = s.formatted_value(line, 'T')
      income_source = s.formatted_value(line, 'U')
      family_expenditure = s.formatted_value(line, 'V')
      expenditure_information = s.formatted_value(line, 'W')
      debt_information = s.formatted_value(line, 'X')
      family_condition = s.formatted_value(line, 'Y')
      reason = s.formatted_value(line, 'Z')

      _nation = nation.split('-').second.to_i
      _level = level.split('-').second.to_i
      _grade = grade.split('-').second.to_i
      _semester = semester.split('-').second.to_i

      child = ProjectSeasonApplyChild.new(project: Project.pair_project, season: project_apply.season, apply: project_apply, school: project_apply.school, name: name, id_card: id_card, nation: _nation, level: _level, grade: _grade, semester: _semester, teacher_name: teacher_name, teacher_phone: teacher_phone, description: description, father: father, father_job: father_job, mother: mother, mother_job: mother_job, parent_information: parent_information, guardian: guardian, guardian_relation: guardian_relation, guardian_phone: guardian_phone, address: address, family_income: family_income, income_source: income_source, family_expenditure: family_expenditure, expenditure_information: expenditure_information, debt_information: debt_information, family_condition: family_condition, reason: reason, province: project_apply.province, city: project_apply.city, district: project_apply.district)
      if ProjectSeasonApplyChild.allow_apply?(project_apply.school, child.id_card)
        if child.approve_pass
          child_ids.push(child.id)
        else
          ProjectSeasonApplyChild.where(id: child_ids).destroy_all
          return {status: false, message: "导入失败：名单第#{line}行数据有误#{child.errors.full_messages.join(',')}"}
        end
      else
        ProjectSeasonApplyChild.where(id: child_ids).destroy_all
        return {status: false, message: "导入失败：名单第#{line}行，本批次身份证号已占用"}
      end

    end

    return {status: true, message: "导入成功"}
  end

  def self.import_camp_members(original_filename: nil, path: nil, apply_camp: nil, kind: nil)
    s = nil
    if File.extname(original_filename) == '.xlsx'
      s = Roo::Excelx.new path
    else
      return {status: false, message: "格式不支持"}
    end
    member_ids = []
    2.upto(s.last_row) do |line|

      index = s.formatted_value(line, 'A')
      name = s.formatted_value(line, 'B')
      id_card = s.cell(line, 'C')
      nation = s.formatted_value(line, 'D')
      if kind == 'student'
        level = s.formatted_value(line, 'E')
        grade = s.formatted_value(line, 'F')
        classname = s.formatted_value(line, 'G')
        height = s.formatted_value(line, 'H')
        weight = s.formatted_value(line, 'I')
        guardian = s.formatted_value(line, 'J')
        guardian_id_card = s.formatted_value(line, 'K')
        guardian_relation = s.formatted_value(line, 'L')
        guardian_phone = s.formatted_value(line, 'M')

        if level == '初中'
          _level = 'junior'
        elsif level == "高中"
          _level = 'senior'
        elsif level == '小学'
          _level = 'primary'
        end

        if grade == '一年级'
          _grade = 'one'
        elsif grade == '二年级'
          _grade = 'two'
        elsif grade == '三年级'
          _grade = 'three'
        elsif grade == '四年级'
          _grade = 'four'
        elsif grade == '五年级'
          _grade = 'five'
        elsif grade == '六年级'
          _grade = 'six'
        end
      else
        phone = s.formatted_value(line, 'E')
        cloth_size = s.formatted_value(line, 'F')
        course_type = s.formatted_value(line, 'G')
        course_grade = s.formatted_value(line, 'H')
        period = s.formatted_value(line, 'I')
        position = s.formatted_value(line, 'J')
        train_experience = s.formatted_value(line, 'K')
        project_experience = s.formatted_value(line, 'L')
        honor_experience = s.formatted_value(line, 'M')
      end

      _nation = nation.split('-').second.to_i

      member = ProjectSeasonApplyCampMember.new(kind: kind, camp: apply_camp.camp, apply: apply_camp.apply, school: apply_camp.school, apply_camp: apply_camp, name: name, id_card: id_card, nation: _nation, level: _level, grade: _grade, classname: classname, guardian_name: guardian, guardian_phone: guardian_phone, phone: phone, height: height, weight: weight, guardian_id_card: guardian_id_card, guardian_relation: guardian_relation, cloth_size: cloth_size, course_type: course_type, course_grade: course_grade, period: period, position: position, train_experience: train_experience, project_experience: project_experience, honor_experience: honor_experience)

      if ProjectSeasonApplyCampMember.allow_apply?(apply_camp, member.id_card, member)
        if member.save
          member_ids.push(member.id)
        else
          ProjectSeasonApplyCampMember.where(id: member_ids).destroy_all
          return {status: false, message: "导入失败：名单第#{line}行数据有误#{member.errors.full_messages.join(',')}"}
        end
      else
        ProjectSeasonApplyCampMember.where(id: member_ids).destroy_all
        return {status: false, message: "导入失败：名单第#{line}行，本批次身份证号已占用"}
      end

    end

    return {status: true, message: "导入成功"}
  end

  def self.import_camp_volunteers(original_filename: nil, path: nil, apply: nil, user: nil)
    s = nil
    if File.extname(original_filename) == '.xlsx'
      s = Roo::Excelx.new path
    else
      return {status: false, message: "格式不支持"}
    end
    volunteer_ids = []
    2.upto(s.last_row) do |line|

      index = s.formatted_value(line, 'A')
      name = s.formatted_value(line, 'B')
      volunteer_no = s.cell(line, 'C')
      id_card = s.cell(line, 'D')
      phone = s.formatted_value(line, 'E')
      content = s.formatted_value(line, 'F')
      remark = s.formatted_value(line, 'G')

      volunteer = CampDocumentVolunteer.new(user: user, camp: apply.camp, apply: apply, name: name, volunteer_no: volunteer_no, id_card: id_card, phone: phone, content: content, remark: remark)
      if volunteer.save
        volunteer_ids.push(volunteer.id)
      else
        CampDocumentVolunteer.where(id: volunteer_ids).destroy_all
        return {status: false, message: "导入失败：名单第#{line}行数据有误#{volunteer.errors.full_messages.join(',')}"}
      end

    end

    return {status: true, message: "导入成功"}
  end

end
