FactoryBot.define do
  factory :project_quotum, class: 'ProjectQuota' do
    school_id 1
    project_id 1
    amount "9.99"
    province "MyString"
    city "MyString"
    district "MyString"
  end
end
