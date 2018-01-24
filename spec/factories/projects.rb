# == Schema Information
#
# Table name: projects
#
#  id                         :integer          not null, primary key
#  type                       :string                                 # 单表继承字段
#  kind                       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name                       :string                                 # 项目名称
#  describe                   :text                                   # 简介
#  protocol                   :text                                   # 用户协议
#  fund_id                    :integer                                # 关联财务分类id
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  donate_record_amount_count :decimal(14, 2)   default(0.0)          # 累计捐助金额
#

FactoryBot.define do
  factory :project, aliases: [:pair_project] do
    name '结对'
    describe '一对一结对项目'
    kind 'normal'
    protocol '用户协议'

    trait :with_seasons do
      after(:build) do |project|
        create_list :project_season, 2, project: project
      end
    end

    trait :with_project_reports do
      after(:build) do |project|
        create_list :project_report, 6, project: project
      end
    end

    trait :with_grant_reports do
      after(:build) do |project|
        create_list :project_report, 6, project: project, kind: 3
      end
    end

    trait :with_donate_records do
      after(:build) do |project|
        create_list :project_report, 6, project: project
      end
    end
  end

end
