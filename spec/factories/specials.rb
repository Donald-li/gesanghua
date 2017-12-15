# == Schema Information
#
# Table name: specials
#
#  id           :integer          not null, primary key
#  name         :string                                 # 位置
#  template     :integer                                # 位置
#  describe     :integer                                # 位置
#  article_name :integer                                # 位置
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :special do
    
  end
end
