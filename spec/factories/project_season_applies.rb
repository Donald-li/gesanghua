# == Schema Information
#
# Table name: project_season_applies # 项目执行年度申请表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联项目执行年度的id
#  school_id         :integer                                # 关联学校id
#  teacher_id        :integer                                # 负责项目的老师id
#  describe          :text                                   # 描述、申请要求
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  state             :integer          default("show")       # 状态：1:展示 2:隐藏
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string                                 # 名称
#  number            :integer                                # 配额
#  apply_no          :string                                 # 项目申请编号
#  bookshelf_type    :integer                                # 悦读项目申请类型
#  contact_name      :string                                 # 联系人姓名
#  contact_phone     :string                                 # 联系人电话
#  audit_state       :integer                                # 审核状态
#  abstract          :string                                 # 简述
#  address           :string                                 # 详细地址
#

FactoryBot.define do
  factory :project_season_apply, aliases: [:apply] do
    province '630000'
    city '630100'
    district '630123'
    state 1
  end
end
