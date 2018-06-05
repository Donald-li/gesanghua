# 旧数据迁移工具类
class MigrateHelper

  # 捐助人
  class EDonor < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_Donor'; self.primary_key = 'DonorId'; end
  # 用户
  class EMyProfile < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_MyProfile'; self.primary_key = 'DvUserName'; end
  # 学校
  class ESchool < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_School'; self.primary_key = 'SchoolId'; end
  # 教师
  class ETeacher < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_Teacher'; self.primary_key = 'TeacherId'; end
  # 学生
  class EStudent < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_Student'; self.primary_key = 'StudentId'; end
  # 捐款记录
  class EEndowLog < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_EndowLog'; self.primary_key = 'EndowId'; end
  # 发放记录
  class EGrantLog < ApplicationRecord; establish_connection :old_data; self.table_name = 'E_GrantLog'; self.primary_key = 'GrantLogId'; end
  # 地区
  class EDistrict < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_District'; self.primary_key = 'DistrictId'
    def self.codes(province, city, county, auto_match = true)
      province = ChinaCity.list.detect{|c|c[0][0,2] == province.to_s[0,2]}.try(:second)
      province ||= ChinaCity.list.first.try(:second) if auto_match
      city = ChinaCity.list(province).detect{|c|c[0][0,2] == city.to_s[0,2]}.try(:second)
      city ||= ChinaCity.list(province).first.try(:second) if province == city
      city ||= ChinaCity.list(province).first.try(:second) if auto_match
      district = ChinaCity.list(city).detect{|c|c[0][0,2] == county.to_s[0,2]}.try(:second)
      district ||= ChinaCity.list(city).first.try(:second) if county == city
      district ||= ChinaCity.list(city).first.try(:second) if auto_match # 再不行用第一个
      return province, city, district
    end
  end
  # 照片
  class EPhoto < ApplicationRecord; establish_connection :old_data; self.table_name = 'e_Photo'; self.primary_key = 'PhotoId'
    def tmp_file # 保存临时文件
      if self.FileName
        path = File.join('/data', 'www', 'bak', self.FileName)
      else
        FileUtils.mkdir_p Rails.root.join('log', 'cache', 'photo')
        path = Rails.root.join('log', 'cache', 'photo', "#{self.StudentId}.jpg")
        File.open(path, 'wb'){|file| file.write self.Data} unless File.exist?(path)
        path
      end
    end
  end

  LIMIT = nil
  # LIMIT = 1000
  SORT = 'ASC'

  def self.do_all_migrate!
    ApplicationRecord.transaction do
      MigrateHelper.migrate_donors
      MigrateHelper.set_agent_users
      # MigrateHelper.migrate_profiles
      MigrateHelper.migrate_schools
      MigrateHelper.migrate_teachers
      MigrateHelper.migrate_children
      MigrateHelper.migrate_donations
      MigrateHelper.clean_data
    end
  end

  # 迁移用户、捐助人
  def self.migrate_donors
    count = EDonor.count
    i = 1
    EDonor.order("DonorId #{SORT}").limit(LIMIT).find_each(batch_size: 1000) do |donor|
      puts "迁移捐款人 #{i} / #{count}"
      user = User.new
      # user.login = donor.DvUserName
      user.nickname = donor.DvUserName
      user.name = donor.Name
      user.gender = :male if donor.Sex == '男'
      user.gender = :female if donor.Sex == '女'
      user.address = donor.Address
      user.qq = donor.QQ
      user.email = donor.Email
      user.phone = donor.Mobile
      user.created_at = donor.AppendDate
      user.state = :unactived
      districts = donor.Address2.to_s.split(',')
      if districts.present?
        user.province, user.city, user.district = EDistrict.codes(districts[0], districts[1], districts[2])
      end
      user.archive_data = donor.attributes
      user.save!(validate: false)
      i = i + 1
    end

  end

  # 处理捐助人和代捐人
  def self.set_agent_users
    xlsx = Roo::Spreadsheet.open(Rails.root.join('lib','assets','donors.xlsx').to_s)
    sheet = xlsx.sheet(0).to_a # DonorId, Mobile, '是/否'
    count = sheet.count
    i = 1
    sheet.each do |line|
      puts "处理代捐人 #{i} / #{count}"
      next if line.second.blank?
      if line.third == '是'
        user = User.where("archive_data ->> 'DonorId' = ?", line.first.to_s).first
        next unless user
        # 其余这个电话号码的都设置为代捐人
        User.where(phone: line.second.to_s).where.not(id: user.id).update_all(phone: nil, manager_id: user.id)
      end
      i = i + 1
    end

    # 检查邮箱是否合法
    User.find_each(batch_size:1000) do |user|
      unless user.valid?
        if user.errors.has_key?(:email)
          pp user.email.to_s
          user.email = nil
          user.save(validate: false)
        elsif user.errors.has_key?(:phone)
          pp user.phone.to_s
          user.phone = nil
          user.save(validate: false)
        else
          pp user.errors.full_messages.join(', ')
        end
      end
    end
  end

  # 迁移用户、捐助人, 不用处理用户Profile了
  # def self.migrate_profiles
  #   count = EMyProfile.count
  #   i = 1
  #   EMyProfile.limit(LIMIT).find_each(batch_size: 1000) do |profile|
  #     puts "迁移用户账号 #{i} / #{count}"
  #     if profile.DonorId.to_i > 0
  #       user = User.where("archive_data ->> 'DonorId' = ?", profile.DonorId.to_s).first if profile.DonorId.present?
  #       if user
  #         user.nickname ||= profile.DvUserName.downcase.strip
  #         user.gender ||= :male if profile.Sex == '男'
  #         user.gender ||= :female if profile.Sex == '女'
  #         user.address ||= profile.Address
  #         user.qq ||= profile.QQ
  #         user.email ||= profile.Email
  #         user.phone ||= profile.Mobile
  #         user.save!(validate: false)
  #       end
  #     else
  #       user = User.new
  #       user.nickname ||= profile.DvUserName.downcase.strip
  #       user.gender = :male if profile.Sex == '男'
  #       user.gender = :female if profile.Sex == '女'
  #       user.address = profile.Address
  #       user.qq = profile.QQ
  #       user.email = profile.Email
  #       user.phone = profile.Mobile
  #       user.archive_data = profile.attributes
  #       user.state = :unactived
  #       user.save!(validate: false)
  #     end
  #     i = i + 1
  #   end
  # end

  # 迁移学校
  def self.migrate_schools
    count = ESchool.count
    i = 1
    ESchool.order("SchoolId #{SORT}").limit(LIMIT).find_each(batch_size: 1000) do |eschool|
      puts "迁移学校 #{i} / #{count}"
      school = School.new
      school.name = eschool.Name
      school.address = eschool.Address
      school.postcode = eschool.PostCode
      school.contact_name = eschool.Principal
      school.contact_phone = eschool.PrincipalMobile.presence || eschool.OfficePhone
      school.created_at = eschool.AppendDate
      school.level = :primary if eschool.SchoolGradeKey == 1
      school.level = :junior if eschool.SchoolGradeKey == 2
      school.level = :senior if eschool.SchoolGradeKey == 4
      school.level = :abbreviation if eschool.SchoolGradeKey == 8
      school.approve_state = :pass
      district = EDistrict.find_by(DistrictId: eschool.DistrictId)
      if district
        school.province, school.city, school.district = EDistrict.codes(district.Province, district.City, district.County)
      end
      school.archive_data = eschool.attributes
      school.save!(validate: false)
      i = i + 1
    end
  end

  # 迁移教师
  def self.migrate_teachers
    count = ETeacher.count
    i = 1
    ETeacher.order("TeacherId #{SORT}").limit(LIMIT).find_each(batch_size: 1000) do |eteacher|
      puts "迁移教师 #{i} / #{count}"

      teacher = Teacher.new
      teacher.name = eteacher.Name
      teacher.nickname = eteacher.Name
      school = School.where("archive_data ->> 'SchoolId' = ?", eteacher.SchoolId.to_s).first if eteacher.SchoolId.present?
      teacher.school = school
      teacher.phone = eteacher.Mobile.presence || eteacher.OfficePhone
      teacher.qq = eteacher.QQ
      teacher.created_at = eteacher.AppendDate
      user = User.find_by(phone: eteacher.Mobile)
      teacher.user = user
      if eteacher.Remarks.include?('校长')
        teacher.kind = :headmaster
      else
        teacher.kind = :teacher
      end
      teacher.archive_data = eteacher.attributes
      teacher.save!(validate: false)
      i = i + 1
    end
  end

  # 迁移受助孩子
  def self.migrate_children
    count = EPhoto.count
    i = 1
    EPhoto.limit(LIMIT).find_each(batch_size: 1000) do |ephoto|
      puts "迁移孩子照片 #{i} / #{count}"
      ephoto.tmp_file
      i = i + 1
    end

    # 建项目和批次
    project = Project.pair_project
    project_season = ProjectSeason.create(name: '历史数据导入', state: :disable, project: project,
      junior_term_amount: Settings.junior_term_amount, junior_year_amount: Settings.junior_year_amount,
      senior_term_amount: Settings.senio_term_amount, senior_year_amount: Settings.senior_year_amount
    )

    count = EStudent.count
    i = 1
    EStudent.limit(LIMIT).order("StudentId #{SORT}").find_each(batch_size: 1000) do |estudent|
      puts "迁移孩子 #{i} / #{count}"
      # 每个学校建申请
      school = School.where("archive_data->>'SchoolId' = ?", estudent.SchoolId.to_s).first
      next unless school
      apply = project_season.applies.find_or_initialize_by(school_id: school.id)
      apply.project = project
      apply.season = project_season
      apply.number = 0
      apply.province = school.province
      apply.city = school.city
      apply.district = school.district
      apply.audit_state = :pass
      apply.pair_state = :pair_complete
      apply.save
      # 建孩子
      child = apply.children.new
      child.project = project
      child.season = project_season
      child.school = school
      child.level = school.level# unless school.primary? || school.abbreviation? # TODO: 有小学的
      # pp school if school.primary? || school.abbreviation?
      child.grade = estudent.Grade.to_i if estudent.Grade.present? && (estudent.Grade.to_i >= 1 && estudent.Grade.to_i <= 3)
      child.grade ||= 1
      teacher = Teacher.where("archive_data->>'TeacherId' = ?", estudent.TeacherId.to_s).first if estudent.TeacherId.present?
      child.teacher_name = teacher.try(:name)
      child.classname = estudent.attributes['Class']
      child.gender = :male if estudent.Sex == '男'
      child.gender = :female if estudent.Sex == '女'
      child.name = estudent.Name
      child.nation = ProjectSeasonApplyChild.options_for_select(:nations).detect{|a|a.first == estudent.Nation}.try(:second) if estudent.Nation.present?
      child.age = Time.now.year - estudent.Birthday.year if estudent.Birthday.present?
      child.father = estudent.Father
      child.father_job = estudent.FatherJob
      child.mother = estudent.Mother
      child.mother_job = estudent.MotherJob
      child.description = estudent.StudySituation
      child.guardian = estudent.Guardian
      child.guardian_relation = estudent.Relationship
      child.phone = estudent.Tellphone
      child.brothers = estudent.Brothers
      child.address = estudent.Address
      child.family_condition = [estudent.Brothers.presence, estudent.FamilySituation.presence].compact.join("\n")
      child.family_income = estudent.Revenue
      child.income_source = estudent.RevenueFrom
      child.created_at = estudent.AppendDate
      child.remark = estudent.Remarks
      child.information = [estudent.StudySituation.presence, estudent.Brothers.presence, estudent.FamilySituation.presence].compact.join("\n")
      child.kind = :inside # 内部
      child.approve_state = :pass
      user = User.where("archive_data->>'DonorId' = ?", estudent.DonorId.to_s).first if estudent.DonorId.present?
      child.priority_id = user.id if user
      child.archive_data = estudent.attributes

      child.save!(validate: false)

      # child.approve_pass
      gsh_child = child.send :create_gsh_child
      gsh_child.gsh_no = estudent.StudentCode.to_s.strip
      gsh_child.save(validate: false)
      child.gsh_child = gsh_child
      child.save!(validate: false)

      # 照片
      file_path = Rails.root.join('log', 'cache', 'photo', "#{estudent.StudentId}.jpg")
      if File.exist?(file_path)
        begin
          asset = Asset::ApplyChildAvatar.create(file: File.open(file_path))
          child.attach_avatar asset.id
          asset = Asset::GshChildAvatar.create(file: File.open(file_path))
          gsh_child.attach_avatar asset.id
        rescue => e
          puts "处理照片时发生了错误" + e.inspect
        end
      end
      i = i + 1
    end
  end

  #  清除捐款和结对记录
  def self.clean_donations
    GshChildGrant.delete_all
    IncomeRecord.delete_all
    DonateRecord.delete_all
    PaperTrail::Version.delete_all
    Fund.update_all(balance: 0)
    ProjectSeasonApplyChild.update_all(semester_count: 0, done_semester_count: 0)
  end

  # 迁移捐款和结对记录
  def self.migrate_donations
    count = EEndowLog.count
    i = 1
    fund = Fund.find_by(fund_category_id: 3, name: '指定')
    EEndowLog.order("EndowId #{SORT}").limit(LIMIT).find_each(batch_size: 1000) do |log|
      puts "迁移捐款记录 #{i} / #{count}"
      user = User.where("archive_data->>'DonorId' = ?", log.DonorId.to_s).first if log.DonorId.present?
      user ||= User.find_by(nickname: '-1') # 固定的一个配捐用户

      # 捐款记录
      income = IncomeRecord.new
      income.donor = user
      income.agent_id = user.manager_id.presence || user.id
      income.fund = fund
      income.balance = log.DonateAmount
      income.amount = log.DonateAmount
      income.voucher_state = :billed
      income.created_at = log.DonateDate
      income.income_time = log.DonateDate
      income.title = "#{user.try(:nickname)}捐助一对一助学款项"
      income.kind = :offline
      income.archive_data = log.attributes
      income.save!(validate: false)

      # 发放记录
      child = ProjectSeasonApplyChild.where("archive_data->>'StudentId' = ?", log.StudentId.to_s).first
      pp log.attributes if child.blank?
      next unless child
      grant = GshChildGrant.new
      grant.gsh_child = child.gsh_child
      grant.project_season_id = child.project_season_id
      grant.project_season_apply_id = child.project_season_apply_id
      grant.project_season_apply_child_id = child.id
      grant.school_id = child.school_id
      grant.management_fee_state = :accrued
      grant.donate_state = :succeed
      grant.amount = log.GrantedMoney || log.DonateAmount
      grant.state = :granted if log.GrantDate.present?
      grant.granted_at = log.GrantDate
      grant.grant_remark = log.Remarks
      grant.user = user
      # date = log.IssueDate
      grant.title = "#{log.BeginDate.strftime('%Y.%-m')} - #{log.EndDate.strftime('%Y.%-m')} 学年"

      grant.save!(validate: false)

      # 捐赠记录
      agent = User.find(user.manager_id.presence || user.id)
      donate_record = DonateRecord.new
      donate_record.attributes = {
        source: income,
        kind: :user_donate,
        owner: grant,
        amount: log.DonateAmount,
        income_record_id: income.id,
        agent: agent, donor: user,
        school_id: child.school_id,
        created_at: income.created_at
      }
      donate_record.save!(validate: false)

      # 对于当年年级<3年级的，正常发放状态的（不是-1），EndDate是2018年的，补发放记录
      if log.Status != -1 && log.EndDate.strftime('%Y-%m') == '2018-07' && log.Grade.to_i < 3
        year_amount = if child.junior?
          1570
        elsif child.senior?
          2100
        end
        next unless year_amount.to_f > 0

        (3 - log.Grade.to_i).times do |i|
          year = Time.now.year + i
          grant = GshChildGrant.new
          grant.gsh_child = child.gsh_child
          grant.project_season_id = child.project_season_id
          grant.project_season_apply_id = child.project_season_apply_id
          grant.project_season_apply_child_id = child.id
          grant.school_id = child.school_id
          grant.amount = year_amount
          grant.user = user
          # date = log.IssueDate
          grant.title = "#{year}.9 - #{year+1}.7 学期"

          grant.save!(validate: false)
        end
      end

      i = i + 1
    end
  end


  # 重新导入孩子头像和发放照片
  def self.migrate_photos
    # MigrateHelper::EStudent.where.not(PhotoId:nil).find_each do |student|
    #   next unless student.PhotoId.to_i == 0
    #   child = ProjectSeasonApplyChild.where("archive_data->>'StudentId' = ?", student.StudentId.to_s).first
    #   gsh_child = child.gsh_child
    #   photo = MigrateHelper::EPhoto.find_by(PhotoId: student.PhotoId)
    #   file_path = photo.tmp_file
    #
    #   if File.exist?(file_path)
    #     begin
    #       asset = Asset::ApplyChildAvatar.create(file: File.open(file_path))
    #       child.attach_avatar asset.id
    #       asset = Asset::GshChildAvatar.create(file: File.open(file_path))
    #       gsh_child.attach_avatar asset.id
    #     rescue => e
    #       puts "处理照片时发生了错误" + e.inspect
    #     end
    #   end
    #
    # end
    count = MigrateHelper::EEndowLog.where.not(PhotoId:nil).count
    i = 0
    MigrateHelper::EEndowLog.where.not(PhotoId:nil).find_each do |log|
      i = i + 1
      puts "处理发放照片#{i} / #{count}"
      next unless log.PhotoId
      child = ProjectSeasonApplyChild.where("archive_data->>'StudentId' = ?", log.StudentId.to_s).first
      title = "#{log.BeginDate.strftime('%Y.%-m')} - #{log.EndDate.strftime('%Y.%-m')} 学年"
      grant = child.gsh_child_grants.where(title: title).first
      if grant.blank?
        puts "没找到孩子#{log.StudentId}:#{title}"
        next
      end

      photo = MigrateHelper::EPhoto.find_by(PhotoId: log.PhotoId)
      if photo.blank?
        puts "没找到照片#{log.PhotoId}"
        next
      end

      file_path = photo.tmp_file

      if File.exist?(file_path)
        begin
          asset = Asset::GshChildGrantImage.create(file: File.open(file_path))
          grant.attach_images [asset.id]
        rescue => e
          puts "处理照片时发生了错误" + e.inspect
        end
      end
    end
  end

  # 整理数据
  def self.clean_data
    count = User.unactived.count
    i = 1
    User.unactived.limit(LIMIT).find_each(batch_size: 1000) do |user|
      puts "整理账户余额 #{i} / #{count}"
      balance = user.income_records.sum(:amount) - user.donate_records.sum(:amount)
      if balance > 0
        # user.account_records.create!(kind: :adjust, donor: user, amount: balance, remark: '历史数据账户余额', title: '历史数据账户余额')
      end
    end
  end
end
