FactoryBot.define do
  factory :project_report do
    title { FFaker::NameCN.name }
    content '项目报告'
    published_at Time.now
  end
end
