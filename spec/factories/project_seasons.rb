# == Schema Information
#
# Table name: project_seasons # 项目执行年度表
#
#  id                   :bigint(8)        not null, primary key
#  project_id           :integer                                # 关联项目表id
#  name                 :string                                 # 执行年度名称
#  state                :integer                                # 状态 1:未执行 2:执行中
#  junior_term_amount   :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount   :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount   :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount   :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  bookshelf_univalence :decimal(14, 2)   default(0.0)          # 单个图书角金额
#

FactoryBot.define do
  factory :project_season, aliases: [:season] do
    name '2017'
    state 1
    junior_term_amount 1050.0
    junior_year_amount 2100.0
    senior_term_amount 1050.0
    senior_year_amount 2100.0
  end
end
