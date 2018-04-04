FactoryBot.define do
  factory :donation do
    donor {create :user}
    title '捐款说明'
    amount 1000
    owner { create(:donate_item)}


    trait :with_agent do
      agent { create :user }
    end

    trait :with_promoter do
      promoter { create :user }
    end

    trait :with_team do
      team
    end
  end
end
