# -*- encoding : utf-8 -*-
require 'roo'

class FileUtil

    def self.import_income_records(original_filename: nil, path: nil)
      s = nil
      if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
        s = Roo::Excelx.new path
      else
        return
      end

      2.upto(s.last_row) do |line|

        title = s.formatted_value(line, 'A')
        fund_title = s.formatted_value(line, 'B')
        income_time = s.cell(line, 'C')
        amount = s.formatted_value(line, 'D')
        income_source_name = s.formatted_value(line, 'E')
        donor = s.formatted_value(line, 'F')
        donor_phone = s.formatted_value(line, 'G')
        user_name = s.formatted_value(line, 'H')
        remitter_name = s.formatted_value(line, 'I')
        remark = s.formatted_value(line, 'J')
        state = s.formatted_value(line, 'K')

        if state == '已开票'
          state = 'billed'
        else
          state = 'to_bill'
        end

        fund = fund_title.present? ? FundCategory.find_by(name: fund_title.split('-').first).funds.find_by(name: fund_title.split('-').second) : nil
        income_source = IncomeSource.find_by(name: income_source_name) || nil

        user = User.find_by(phone: donor_phone)

        if fund.present?
          income_time = income_time.class.to_s == 'DateTime' || income_time.class.to_s == 'Date' ? income_time : Time.parse(income_time)
          IncomeRecord.create(title: title, fund: fund, income_time: income_time, amount: amount, income_source: income_source, agent: user, donor: donor, remitter_name: remitter_name, remark: remark, voucher_state: state)
        end

      end
    end

    def self.import_expenditure_records(original_filename: nil, path: nil)
      s = nil
      s_count = 0
      f_count = 0
      if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
        s = Roo::Excelx.new path
      else
        return
      end
      #  name：学校名称  contact_name：联系人姓名 contact_title：联系人职位 contact_phone：联系方式 province：省 city：市 district：区 street：街 address：详细地址
      2.upto(s.last_row) do |line|

        name = s.formatted_value(line, 'A')
        expended_at = s.cell(line, 'B')
        fund_title = s.formatted_value(line, 'C')
        amount = s.formatted_value(line, 'D')
        remark = s.formatted_value(line, 'E')
        operator = s.formatted_value(line, 'F')

        fund = fund_title.present? ? FundCategory.find_by(name: fund_title.split('-').first).funds.find_by(name: fund_title.split('-').second) : nil

        if fund.present?
          expended_at = expended_at.class.to_s == 'DateTime' || expended_at.class.to_s == 'Date' ? expended_at : Time.parse(expended_at)
          ExpenditureRecord.create(fund: fund, expended_at: expended_at, amount: amount, operator: operator, name: name, remark: remark)
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
      if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
        s = Roo::Excelx.new path
      else
        return
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

end
