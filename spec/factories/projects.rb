# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  type                  :string                                      # 单表继承字段
#  kind                  :integer                                     # 项目类型 1:固定项目 2:物资类项目
#  name                  :string                                      # 项目名称
#  describe              :text                                        # 简介
#  protocol              :text                                        # 用户协议
#  fund_id               :integer                                     # 关联财务分类id
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  total_amount          :decimal(14, 2)   default(0.0)               # 累计捐助金额
#  alias                 :string                                      # 项目别名，使用英文
#  appoint_fund_id       :integer                                     # 定向指定财务分类id
#  position              :integer                                     # 位置排序
#  form                  :jsonb                                       # 自定义表单{key, label, type, options, required}
#  donate_item_id        :integer                                     # 捐助项id
#  accept_feedback_state :integer                                     # 是否接受定期反馈：1:open_feedback 2:close_feedback
#  feedback_period       :integer                                     # 建议定期反馈次数/年
#  apply_kind            :integer          default("platform_assign") # 申请类型 1:平台分配 2:用户申请
#  feedback_format       :integer                                     # 反馈形式
#  management_rate       :integer
#

FactoryBot.define do
  factory :project, aliases: [:pair_project] do
    name '结对助学'
    describe '结对助学结对助学项目'
    protocol '用户协议'

    trait :read do
      name '悦读'
      describe '悦读项目'
    end

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
