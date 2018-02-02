# == Schema Information
#
# Table name: project_season_apply_bookshelves # 项目执行年度申请书架表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  classname               :string                                 # 班级名
#  title                   :string                                 # 冠名
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  school_id               :integer                                # 学校id
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  audit_state             :integer                                # 审核状态 1:提交 2:通过 3:拒绝
#  show_state              :integer                                # 显示状态 1:显示 2:隐藏
#  state                   :integer                                # 筹款状态:
#  grade                   :integer                                # 年级
#  bookshelf_no            :string                                 # 图书角编号
#  target_amount           :decimal(14, 2)   default(0.0)          # 目标金额
#  present_amount          :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  book_number             :integer                                # 书籍数量
#

FactoryBot.define do
  factory :project_season_apply_bookshelf, aliases: [:bookshelf] do
    classname '初一一班'
    title 'GSH0001'
    target_amount 2100
    province '630000'
    city '630100'
    district '630123'

  end
end
