class AddManyColumnsToVisits < ActiveRecord::Migration[5.1]
  def change
    add_column :visits, :investigador, :string, comment: '调查人员'
    add_column :visits, :escort, :string, comment: '陪同人员'
    add_column :visits, :survey_time, :datetime, comment: '调查时间'
    add_column :visits, :family_size, :integer, comment: '家庭人数'
    add_column :visits, :family_basic, :string, comment: '家庭基本情况'
    add_column :visits, :basic_information, :text, comment: '基本情况'
    add_column :visits, :income_information, :text, comment: '收入情况'
    add_column :visits, :expenditure_information, :text, comment: '支出情况'
    add_column :visits, :lodge, :string, comment: '是否寄宿'
    add_column :visits, :lodge_cost, :decimal, precision: 14, scale: 2, default: 0.0, comment: '住宿费用'
    add_column :visits, :other_subsidize, :text, comment: '其他资助'
    add_column :visits, :prize_information, :text, comment: '获奖情况'
    add_column :visits, :study_information, :text, comment: '学习情况'
    add_column :visits, :tuition_fee, :decimal, precision: 14, scale: 2, default: 0.0, comment: '学杂费'
    add_column :visits, :sponsor_fee, :string, comment: '是否赞助生活费'
  end
end
