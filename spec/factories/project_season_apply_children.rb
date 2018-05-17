# == Schema Information
#
# Table name: project_season_apply_children # 项目执行年度申请的孩子表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  gsh_child_id            :integer                                # 关联格桑花孩子表id
#  name                    :string                                 # 孩子姓名
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  phone                   :string                                 # 电话
#  qq                      :string                                 # QQ号码
#  nation                  :integer                                # 民族
#  id_card                 :string                                 # 身份证号码
#  parent_name             :string                                 # 家长姓名
#  description             :text                                   # 描述
#  state                   :integer                                # 状态
#  approve_state           :integer                                # 审核状态
#  age                     :integer                                # 年龄
#  level                   :integer                                # 初中或高中
#  grade                   :integer                                # 年级
#  gender                  :integer                                # 性别
#  school_id               :integer                                # 学校ID
#  semester                :integer                                # 学期
#  kind                    :integer                                # 捐助形式：1对外捐助 2内部认捐
#  donate_user_id          :integer                                # 捐助人id
#  reason                  :string                                 # 结对申请理由
#  gsh_no                  :string                                 # 格桑花孩子编号
#  semester_count          :integer                                # 学期数
#  done_semester_count     :integer          default(0)            # 已完成的学期数
#  user_id                 :integer                                # 关联的用户ID
#  teacher_name            :string                                 # 班主任
#  father                  :string                                 # 父亲
#  father_job              :string                                 # 父亲职业
#  mother                  :string                                 # 母亲
#  mother_job              :string                                 # 母亲职业
#  guardian                :string                                 # 监护人
#  guardian_relation       :string                                 # 与监护人关系
#  guardian_phone          :string                                 # 监护人电话
#  address                 :string                                 # 家庭住址
#  family_income           :decimal(14, 2)   default(0.0)          # 家庭年收入
#  family_expenditure      :decimal(14, 2)   default(0.0)          # 家庭年支出
#  income_source           :string                                 # 收入来源
#  family_condition        :string                                 # 家庭情况
#  brothers                :string                                 # 兄弟姐妹
#  teacher_phone           :string                                 # 班主任联系方式
#  remark                  :text                                   # 备注
#  expenditure_information :text                                   # 支出详情
#  debt_information        :text                                   # 负债情况
#  parent_information      :string                                 # 父母情况
#  information             :text                                   # 对外展示的孩子介绍
#

FactoryBot.define do
  factory :project_season_apply_child, aliases: [:child] do
    name '李同学'
    province '630000'
    city '630100'
    district '630123'
    id_card '370202198411195417'
    age 13
    level 1
    grade 1
    semester 1
    parent_name '李爹'
    information '挂多小学地处偏远，道路崎岖，校舍修建于上世纪80年代，破损陈旧，已列为B级危房。窗户上玻璃破损，课桌破烂不堪。现有学生共计约135人，新建的主体教学楼3层，明亮宽敞，现已于2011年冬季正式投入使<br/>\r\n\r\n  <img src=\"http://photocdn.sohu.com/20140620/Img401121227.jpg\"> <br>\r\n             <img src=\"http://photocdn.sohu.com/20140620/Img401121228.jpg\"><br/>\r\n\r\n跟随爱的呼唤，6月13日上午，顶固“给孩子送双运动鞋”爱心希望之旅贵州站在贵州挂多顶固希望小学正式启动。爱心活动在孩子们的欢笑中，在义工为孩子们上课的快乐课堂上，在激动人心的足球比赛中落下帷幕。孩子们穿上崭新的运动鞋，快乐奔跑在成长路上！<br/>\r\n'
    sequence(:phone) { |n| "18888#{n.to_s.rjust(6,'0')}" }
  end
end
