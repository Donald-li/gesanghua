# == Schema Information
#
# Table name: sequences
#
#  id         :bigint(8)        not null, primary key
#  kind       :string
#  prefix     :string
#  value      :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Sequence, type: :model do
  it "测试生成序列号的功能" do
    seq = Sequence.get_seq(kind: :user_no, prefix: '201712', length: 4)
    expect(seq.length).to eq(10)
    expect(seq).to end_with('1')
    seq = Sequence.get_seq(kind: :user_no, prefix: '201712', length: 4)
    expect(seq).to end_with('2')
    seq = Sequence.get_seq(kind: :user_no, prefix: '201801', length: 4)
    expect(seq).to end_with('1')
  end
end
