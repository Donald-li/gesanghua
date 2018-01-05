# == Schema Information
#
# Table name: projects
#
<<<<<<< HEAD
#  id                 :integer          not null, primary key
#  type               :string                                 # 单表继承字段
#  kind               :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name               :string                                 # 项目名称
#  describe           :text                                   # 简介
#  protocol           :text                                   # 用户协议
#  fund               :integer                                # 关联财务分类id
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  junior_term_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
=======
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  describe   :text                                   # 简介
#  protocol   :text                                   # 用户协议
#  fund_id    :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
>>>>>>> 554394f4b9ee31f1201ffe57283adc8e6eac2e58
#

class Movie < Project
end
